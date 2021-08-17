//
//  BGFrameworkCentralManager.swift
//  BGFramework
//
//  Created by Shridhara V on 19/03/21.
//

import Foundation
import BackgroundTasks
import CoreData
import UIKit

protocol BGFrameworkCentralManagerProtocol {
    func scheduleRequiredTasks()
}

struct BGTaskWrapperDebgu: BGTaskWrapperProtocol {
    var identifier: String
    
    var expirationHandler: (() -> Void)?
    
    func setTaskCompleted(success: Bool) {
    }
}

class BGFrameworkCentralManager: BGFrameworkCentralManagerProtocol {
    
    init(registrationDataController: BGSyncItemRegistrationDataProtocol,
         configurationProvidable: BGConfigurationProvidable,
         moc: NSManagedObjectContext,
         bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type = BGTaskSchedulerWrapper.self,
         orchestrator: BGTaskOrchestratorProtocol.Type = BGTaskOrchestrator.self,
         scheduler: TaskSchedulerProtocol.Type = TaskScheduler.self,
         bgTaskProcessControllerType: BGTaskProcessControllerProtocol.Type = BGTaskProcessController.self,
         notificationCenter: NotificationCenter = NotificationCenter.default,
         logger: BGLogger = BGLoggerManager.shared) {
        
        self.registrationDataController = registrationDataController
        self.configurationProvidable = configurationProvidable
        self.moc = moc
        self.bgTaskScheduler = bgTaskScheduleWrapper
        self.orchestrator = orchestrator
        self.scheduler = scheduler
        self.bgTaskProcessControllerType = bgTaskProcessControllerType
        self.notificationCenter = notificationCenter
        self.logger = logger
        
        registerBGTasks()
        
        observeNotifications()
    }
    
    func scheduleRequiredTasks() {
        let orchestratorObj = orchestrator.init(registeredUsecases: registrationDataController.registeredUsecases)
        let scheduleObj = scheduler.init(configProvidable: configurationProvidable,
                                         bgTaskScheduleWrapper: BGTaskSchedulerWrapper.self,
                                         orchestrator: orchestratorObj,
                                         logger: logger)
        scheduleObj.scheduleRequiredTasks {
            debugLog("Scheduled tasks")
        }
    }
    
    private let registrationDataController: BGSyncItemRegistrationDataProtocol
    private let configurationProvidable: BGConfigurationProvidable
    private let moc: NSManagedObjectContext
    private let bgTaskScheduler: BGTaskSchedulerWrapperProtocol.Type
    private let orchestrator: BGTaskOrchestratorProtocol.Type
    private let scheduler: TaskSchedulerProtocol.Type
    private let bgTaskProcessControllerType: BGTaskProcessControllerProtocol.Type
    private let notificationCenter: NotificationCenter
    private let logger: BGLogger
}

extension BGFrameworkCentralManager {
    
    private func registerBGTasks() {
        guard let registrationData = self.configurationProvidable.registrationData else {
            preconditionFailure("Registration data not found")
        }
        
        registrationData.permittedIdentifiers.forEach { keyValue in
            if self.orchestrator.canRegisterTask(identifier: keyValue.value) {
                let isRegistered = self.bgTaskScheduler.register(forTaskWithIdentifier: keyValue.value,
                                                                 using: nil) { task in
                    self.bgTaskHandler(task: task)
                }
                
                if isRegistered {
                    self.logger.taskRegistered(withIdentifier: keyValue.value)
                } else {
                    self.logger.failedToRegister(withIdentifier: keyValue.value)
                }
            } else {
                preconditionFailure("Key: \(keyValue.value) not found in info.plist")
            }
        }
    }
    
    private func bgTaskHandler(task: BGTaskWrapperProtocol) {
        
        guard let registrationData = self.configurationProvidable.registrationData else {
            assertionFailure("Registration data not found")
            task.setTaskCompleted(success: false)
            return
        }
        
        guard let type = registrationData.permittedIdentifiers.first(where: { $0.value == task.identifier })?.key else {
            assertionFailure("didn't find the element in permittedIdentifiers")
            task.setTaskCompleted(success: false)
            return
        }
        
        let taskUniqueId = UUID().uuidString
        let taskData = BGTaskData(taskUniqueId: taskUniqueId, identifier: task.identifier, taskType: type.taskType)
        
        self.logger.backgroundTaskLaunched(for: taskData)
        
        switch type {
        case .appRefreshTask,
             .processingTaskWithConnectivityWithExternalPower,
             .processingTaskWithConnectivityWithoutExternalPower:
            //All applicable but withoutConnectivityTasks are low priority.
            process(categories: [.connectivityTasks, .withoutConnectivityTasks], task: task, taskData: taskData)
        case .processingTaskWithoutConnectivity:
            //only no connectivity tasks applicable
            process(categories: [.withoutConnectivityTasks], task: task, taskData: taskData)
        }
    }
    
    private func process(categories: [Constants.TaskCategory], task: BGTaskWrapperProtocol, taskData: BGTaskData) {
        var bgTask = task
        var isTaskFinished = false
        
        debugLog("Task: \(bgTask.identifier) began")
        
        scheduleRequiredTasks()
        
        guard let configuration = configurationProvidable.registrationData else {
            assertionFailure("didn't find masterConfiguration")
            bgTask.setTaskCompleted(success: true)
            return
        }
        
        let startTime = Date()
        
        let processController = bgTaskProcessControllerType.init(categories: categories,
                                                                 registrationDataController: registrationDataController,
                                                                 configuration: configuration,
                                                                 moc: moc,
                                                                 logger: self.logger,
                                                                 taskData: taskData)
        
        func setTaskCompleted(logger: BGLogger?) {
            isTaskFinished = true
            let timeTakenDuration = Date().timeIntervalSince(startTime)
            logger?.taskCompleted(for: taskData, timeTakenDuration: timeTakenDuration)
            bgTask.setTaskCompleted(success: true)
        }
        
        bgTask.expirationHandler = { [weak self] in
            self?.logger.expirationHandler(for: taskData)
            debugLog("ExpirationHandler for Task: \(bgTask.identifier)")
            processController.stopProcessing()
            setTaskCompleted(logger: self?.logger)
        }
        
        if configurationProvidable.scheduleSettings.enable == false ||
            registrationDataController.registeredUsecases.isEmpty {
            //This is the waiting mechanism for allowing the usecases to get registered and allowing the app to enable settings
            let dispatchSemaphore = DispatchSemaphore(value: 0)
            
            _ = dispatchSemaphore.wait(timeout: .now() + configuration.minWaitingPeriodForRegistration)
        }
        
        guard !isTaskFinished else {
            //Task has been completed already. So need to perform anything and no need to call setTaskCompleted method.
            //This case can occur only due to the above Semaphore blocking case.
            return
        }
        
        guard configurationProvidable.scheduleSettings.enable,
              !registrationDataController.registeredUsecases.isEmpty else {
            setTaskCompleted(logger: self.logger)
            return
        }
        
        processController.process { [weak self] in
            debugLog("Completed Task: \(bgTask.identifier)")
            setTaskCompleted(logger: self?.logger)
        }
    }
}

extension BGFrameworkCentralManager {
    private func observeNotifications() {
        notificationCenter.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc
    private func appDidEnterBackground() {
        scheduleRequiredTasks()
    }
    
//    @objc
//    private func appDidBecomeActive() {
        //Assuming all the use cases would be synced with their data. So setting last sync time to current time.
//        let allIdentifiers = registrationDataController.registeredUsecases.map { $0.identifier }
//        CDSyncItemUtil.updateLastSyncTime(for: allIdentifiers, moc: moc)
//    }
}
