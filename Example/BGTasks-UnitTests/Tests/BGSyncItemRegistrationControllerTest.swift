//
//  BGSyncItemRegistrationControllerTest.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 20/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Quick
@testable import BGTasks
import BackgroundTasks
import Senpai

class BGSyncItemRegistrationControllerTest: QuickSpec {
    
    override func spec() {
        guard #available(iOS 13.0, *) else {
            return
        }
        
        describe("BGSyncItemRegistrationController Tests") {
            beforeEach {
                BGLoggerManager.shared.register(logger: self.logger)
            }
            
            context("registerSyncItem") {
                it("registering with different item identifers") {
                    let registrationController = BGSyncItemRegistrationController(
                        configProvidable: TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"])),
                        scheduler: TestTaskScheduler.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        logger: BGLoggerManager.shared
                    )
                    
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                    
                    let syncItem1 = BGSyncRegistrationData(identifier: "id_1", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem1)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                    
                    let syncItem2 = BGSyncRegistrationData(identifier: "id_2", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem2)
                    expecting(registrationController.registeredUsecases.count).to(equal(2))
                }
                
                it("registering with same item identifers") {
                    let registrationController = BGSyncItemRegistrationController(
                        configProvidable: TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"])),
                        scheduler: TestTaskScheduler.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        logger: BGLoggerManager.shared
                    )
                    
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                    
                    let syncItem1 = BGSyncRegistrationData(identifier: "id_1", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem1)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                    
                    let syncItem2 = BGSyncRegistrationData(identifier: "id_1", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem2)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                }
            }
            
            context("unRegisterSyncItem") {
                it("unregistering with different item identifers") {
                    let registrationController = BGSyncItemRegistrationController(
                        configProvidable: TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"])),
                        scheduler: TestTaskScheduler.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        logger: BGLoggerManager.shared
                    )
                    
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                    
                    let identifier = "id_1"
                    let syncItem1 = BGSyncRegistrationData(identifier: identifier, configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem1)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                    
                    registrationController.unRegisterSyncItem("id_2")
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                }
                
                it("unregistering with same item identifers") {
                    let registrationController = BGSyncItemRegistrationController(
                        configProvidable: TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"])),
                        scheduler: TestTaskScheduler.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        logger: BGLoggerManager.shared
                    )
                    
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                    
                    let identifier = "id_1"
                    let syncItem1 = BGSyncRegistrationData(identifier: identifier, configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem1)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                    
                    registrationController.unRegisterSyncItem(identifier)
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                }
            }
            
            context("resetAllSyncItems") {
                it("unregistering with different item identifers") {
                    let registrationController = BGSyncItemRegistrationController(
                        configProvidable: TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"])),
                        scheduler: TestTaskScheduler.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        logger: BGLoggerManager.shared
                    )
                    
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                    
                    let syncItem1 = BGSyncRegistrationData(identifier: "id_1", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem1)
                    expecting(registrationController.registeredUsecases.count).to(equal(1))
                    
                    let syncItem2 = BGSyncRegistrationData(identifier: "id_2", configuration: .init(strategy: .everyTime)) { compl in
                        compl(true)
                    }
                    registrationController.registerSyncItem(syncItem2)
                    expecting(registrationController.registeredUsecases.count).to(equal(2))
                    
                    registrationController.resetAllSyncItems()
                    expecting(registrationController.registeredUsecases.count).to(equal(0))
                }
            }
        }
    }
    
    private let logger = TestLogger()
}

class TestTaskScheduler: TaskSchedulerProtocol {
    required init(configProvidable: BGConfigurationProvidable,
                  bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type,
                  orchestrator: BGTaskOrchestratorProtocol,
                  logger: BGLogger) {
    }
    
    func scheduleRequiredTasks(completion: @escaping () -> Void) {
        completion()
    }
    
    func cancelAllTaskRequests() {
    }
}

func performWith(delay: TimeInterval, clouser: @escaping EmptyCompletion) {
    if Thread.isMainThread {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: clouser)
    } else {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: clouser)
    }
}
