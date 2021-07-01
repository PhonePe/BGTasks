//
//  BGServiceBuilders.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation

final class BGServiceBuilders {
    static let shared = BGServiceBuilders()
    
    private(set) lazy var registrationController = BGSyncItemRegistrationController(configProvidable: BGConfigurationProvider.shared,
                                                                                scheduler: TaskScheduler.self,
                                                                                orchestrator: BGTaskOrchestrator.self,
                                                                                bgTaskScheduleWrapper: BGTaskSchedulerWrapper.self,
                                                                                logger: BGLoggerManager.shared)
    
    private(set) lazy var coreDataStackProvider: CoreDataStackProvider = {
        let stack = BGFrameworkCoreDataStack()
        return stack
    }()
    
    private init() {
    }
}
