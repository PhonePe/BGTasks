//
//  TaskSchedulerTests.swift
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

class TaskSchedulerTests: QuickSpec {
    
    override func spec() {
        guard #available(iOS 13.0, *) else {
            return
        }
        
        describe("TaskScheduler Tests") {
            beforeEach {
                TestBGTaskSchedulerWrapper.resetTestData()
                BGLoggerManager.shared.register(logger: self.logger)
            }
            
            context("scheduleRequiredTasks") {
                it("without registration data") {
                    let taskScheduler = TaskScheduler(
                        configProvidable: TestBGConfigurationProvider(registrationData: nil),
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        orchestrator: TestBGTaskOrchestrator(registeredUsecases: []),
                        logger: BGLoggerManager.shared
                    )
                    
                    let expression = {
                        taskScheduler.scheduleRequiredTasks {
                        }
                    }
                    expect(expression).to(throwAssertion())
                }
                
                it("pendingTaskRequests is empty") {
                    waitUntil(timeout: testTimeout) { done in
                        let appRefreshTaskId = "com.phonepe.appreferesh"
                        let processingTaskId = "com.phonepe.processing.task"
                        
                        let registrationData = BGConfigurationProvider.RegistrationData(
                            permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: appRefreshTaskId,
                                                   .processingTaskWithConnectivityWithExternalPower: processingTaskId]
                        )
                        let taskScheduler = TaskScheduler(
                            configProvidable: TestBGConfigurationProvider(registrationData: registrationData),
                            bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                            orchestrator: TestBGTaskOrchestrator(registeredUsecases: []),
                            logger: BGLoggerManager.shared
                        )
                        
                        TestBGTaskSchedulerWrapper.pendingTaskRequests = []
                        taskScheduler.scheduleRequiredTasks {
                            let outPut: Set<String> = [appRefreshTaskId, processingTaskId]
                            expecting(TestBGTaskSchedulerWrapper.submitCalledIdentifiers).to(equal(outPut))
                            done()
                        }
                    }
                }
                
                it("appRefreshTask registered previously but not processing task") {
                    waitUntil(timeout: testTimeout) { done in
                        let appRefreshTaskId = "com.phonepe.appreferesh"
                        let processingTaskId = "com.phonepe.processing.task"
                        
                        let registrationData = BGConfigurationProvider.RegistrationData(
                            permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: appRefreshTaskId,
                                                   .processingTaskWithConnectivityWithExternalPower: processingTaskId]
                        )
                        let taskScheduler = TaskScheduler(
                            configProvidable: TestBGConfigurationProvider(registrationData: registrationData),
                            bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                            orchestrator: TestBGTaskOrchestrator(registeredUsecases: []),
                            logger: BGLoggerManager.shared
                        )
                        
                        TestBGTaskSchedulerWrapper.pendingTaskRequests = [BGAppRefreshTaskRequest(identifier: appRefreshTaskId)]
                        taskScheduler.scheduleRequiredTasks {
                            let outPut: Set<String> = [processingTaskId]
                            expecting(TestBGTaskSchedulerWrapper.submitCalledIdentifiers).to(equal(outPut))
                            done()
                        }
                    }
                }
                
                it("appRefreshTask is registered previously") {
                    waitUntil(timeout: testTimeout) { done in
                        let appRefreshTaskId = "com.phonepe.appreferesh"
                        
                        let registrationData = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: appRefreshTaskId])
                        let taskScheduler = TaskScheduler(
                            configProvidable: TestBGConfigurationProvider(registrationData: registrationData),
                            bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                            orchestrator: TestBGTaskOrchestrator(registeredUsecases: []),
                            logger: BGLoggerManager.shared
                        )
                        
                        TestBGTaskSchedulerWrapper.pendingTaskRequests = [BGAppRefreshTaskRequest(identifier: appRefreshTaskId)]
                        taskScheduler.scheduleRequiredTasks {
                            expecting(TestBGTaskSchedulerWrapper.submitCalledIdentifiers.count).to(equal(0))
                            done()
                        }
                    }
                }
                
                it("processingTask is registered previously") {
                    waitUntil(timeout: testTimeout) { done in
                        let processingTaskId = "com.phonepe.processing.task"
                        
                        let registrationData = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.processingTaskWithConnectivityWithExternalPower: processingTaskId])
                        let taskScheduler = TaskScheduler(
                            configProvidable: TestBGConfigurationProvider(registrationData: registrationData),
                            bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                            orchestrator: TestBGTaskOrchestrator(registeredUsecases: []),
                            logger: BGLoggerManager.shared
                        )
                        
                        TestBGTaskSchedulerWrapper.pendingTaskRequests = [BGProcessingTaskRequest(identifier: processingTaskId)]
                        taskScheduler.scheduleRequiredTasks {
                            expecting(TestBGTaskSchedulerWrapper.submitCalledIdentifiers.count).to(equal(0))
                            done()
                        }
                    }
                }
            }
        }
    }
    
    private let logger = TestLogger()
}
