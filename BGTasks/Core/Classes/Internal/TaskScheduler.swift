//
//  TaskScheduler.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation
import BackgroundTasks

protocol TaskSchedulerProtocol: AnyObject {
    
    init(configProvidable: BGConfigurationProvidable,
         bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type,
         orchestrator: BGTaskOrchestratorProtocol,
         logger: BGLogger)
    
    func scheduleRequiredTasks(completion: @escaping () -> Void)
    func cancelAllTaskRequests()
}

final class TaskScheduler: TaskSchedulerProtocol {
    
    init(configProvidable: BGConfigurationProvidable,
         bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type = BGTaskSchedulerWrapper.self,
         orchestrator: BGTaskOrchestratorProtocol,
         logger: BGLogger) {
        
        self.configProvidable = configProvidable
        self.bgTaskScheduleWrapper = bgTaskScheduleWrapper
        self.orchestrator = orchestrator
        self.logger = logger
    }
    
    func scheduleRequiredTasks(completion: @escaping () -> Void) {
        if configProvidable.scheduleSettings.enable {
            guard let registrationData = configProvidable.registrationData else {
                assertionFailure("No registrationData")
                completion()
                return
            }
            
            self.bgTaskScheduleWrapper.getPendingTaskRequests { requests in
                for task in registrationData.permittedIdentifiers.getUnsafeDictionary() {
                    if !requests.contains(where: { $0.identifier == task.value }) {
                        if self.orchestrator.canSchedule(for: task.key, identifier: task.value) {
                            self.schedule(task: task.key, identifier: task.value)
                        }
                    }
                }
                
                completion()
            }
        }
    }
    
    func cancelAllTaskRequests() {
        self.bgTaskScheduleWrapper.cancelAllTaskRequests()
    }
    
    private let configProvidable: BGConfigurationProvidable
    private let bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type
    private let orchestrator: BGTaskOrchestratorProtocol
    private let logger: BGLogger
}

extension TaskScheduler {
    private func schedule(task: BGTaskSchedulerType, identifier: String) {
        if #available(iOS 13.0, *) {
            guard let configuration = configProvidable.registrationData else {
                return
            }
            
            switch task.taskType {
            case .apprefresh:
                let refreshTask = BGAppRefreshTaskRequest(identifier: identifier)
                refreshTask.earliestBeginDate = Date(timeIntervalSinceNow: configuration.appRefreshTaskScheduleInterval)
                submitRequest(refreshTask)
            case .processing:
                let processingTask = BGProcessingTaskRequest(identifier: identifier)
                processingTask.earliestBeginDate = Date(timeIntervalSinceNow: configuration.processingTaskScheduleInterval)
                processingTask.requiresNetworkConnectivity = task.requiresNetworkConnectivity
                if let externalPower = task.requiresExternalPower {
                    processingTask.requiresExternalPower = externalPower
                }
                
                submitRequest(processingTask)
            case .silentPN:
                assertionFailure("Not a valid type to schedule")
                break
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func submitRequest(_ taskRequest: BGTaskRequest) {
        do {
            try self.bgTaskScheduleWrapper.submit(taskRequest)
            logger.taskScheduled(withIdentifier: taskRequest.identifier)
        } catch {
            logger.failedToScheduleTask(withIdentifier: taskRequest.identifier)
            debugLog("Unable to submit task: \(taskRequest.identifier).\tError: \(error.localizedDescription)")
        }
    }
}
