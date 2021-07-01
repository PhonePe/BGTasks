//
//  BGSyncItemRegistrationController.swift
//  BGFramework
//
//  Created by Shridhara V on 16/03/21.
//

import Foundation

final class BGSyncItemRegistrationController: BGSyncRegistrationProtocol {
    
    init(configProvidable: BGConfigurationProvidable,
         scheduler: TaskSchedulerProtocol.Type,
         orchestrator: BGTaskOrchestratorProtocol.Type,
         bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type,
         logger: BGLogger) {
        self.configProvidable = configProvidable
        self.scheduler = scheduler
        self.orchestrator = orchestrator
        self.bgTaskScheduleWrapper = bgTaskScheduleWrapper
        self.logger = logger
    }
    
    var registeredUsecases: [BGSyncRegistrationData] {
        return registeredUsecasesDict.allValues
    }
    
    func registerSyncItem(_ data: BGSyncRegistrationData) {
        registeredUsecasesDict[data.identifier] = data
        
        let scheduleObj = getScheduleObject()
        scheduleObj.scheduleRequiredTasks {
            debugLog("Scheduled sucessfully")
        }
    }
    
    func unRegisterSyncItem(_ identifier: String) {
        registeredUsecasesDict[identifier] = nil
    }
    
    func resetAllSyncItems() {
        registeredUsecasesDict = .init()
        let scheduleObj = getScheduleObject()
        scheduleObj.cancelAllTaskRequests()
    }
    
    private let configProvidable: BGConfigurationProvidable
    private let scheduler: TaskSchedulerProtocol.Type
    private let orchestrator: BGTaskOrchestratorProtocol.Type
    private let bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type
    private let logger: BGLogger
    
    private var registeredUsecasesDict = ThreadSafeDictionary<String, BGSyncRegistrationData>()
}

extension BGSyncItemRegistrationController {
    private func getScheduleObject() -> TaskSchedulerProtocol {
        let orchestratorObj = orchestrator.init(registeredUsecases: registeredUsecases)
        let scheduleObj = scheduler.init(configProvidable: configProvidable,
                                         bgTaskScheduleWrapper: bgTaskScheduleWrapper,
                                         orchestrator: orchestratorObj,
                                         logger: logger)
        return scheduleObj
    }
}
