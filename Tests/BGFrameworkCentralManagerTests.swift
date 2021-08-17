//
//  BGFrameworkCentralManagerTests.swift
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
import CoreData

class BGFrameworkCentralManagerTests: QuickSpec {
    
    override func spec() {
        guard #available(iOS 13.0, *) else {
            return
        }
        
        describe("BGFrameworkCentralManager Tests") {
            
            beforeEach {
                self.beforeEachTestSetup()
            }
            
            registrationTest()
            taskHandlerTests()
            appDidEnterBackgroundTest()
        }
    }
    
    private func beforeEachTestSetup() {
        self.coreDataManager = MockCoreDataManager(bundles: [Bundle(for: CDHistory.self)])
        self.mockNotificationCenter = MockNotificationCenter(callSuperMethods: true)
        
        TestBGTaskSchedulerWrapper.resetTestData()
        TestBGTaskOrchestrator.resetTestData()
        TestBGTask.resetTestData()
        TestBGTaskProcessController.resetTestData()
        TestTaskScheduler.resetTestData()
    }
    
    //     swiftlint:disable implicitly_unwrapped_optional
    private var coreDataManager: MockCoreDataManager!
    private var mockNotificationCenter: MockNotificationCenter!
    // swiftlint:enable implicitly_unwrapped_optional
}

// MARK: - registerBGTasks method tests
extension BGFrameworkCentralManagerTests {
    private func registrationTest() {
        context("registerBGTasks method tests") {

            it("without registrationData") {
                let expression = {
                    _ = BGFrameworkCentralManager(
                        registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: []),
                        configurationProvidable: TestBGConfigurationProvider(registrationData: nil),
                        moc: self.coreDataManager.newBackgroundContext,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        scheduler: TestTaskScheduler.self,
                        bgTaskProcessControllerType: TestBGTaskProcessController.self,
                        notificationCenter: self.mockNotificationCenter
                    )
                }
                expecting(expression: expression).to(throwAssertion())
            }
            
            it("without permittedIdentifiers") {
                let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [:]))
                
                _ = BGFrameworkCentralManager(
                    registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: []),
                    configurationProvidable: configurationProvider,
                    moc: self.coreDataManager.newBackgroundContext,
                    bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                    orchestrator: TestBGTaskOrchestrator.self,
                    scheduler: TestTaskScheduler.self,
                    bgTaskProcessControllerType: TestBGTaskProcessController.self,
                    notificationCenter: self.mockNotificationCenter
                )
                
                expecting(TestBGTaskSchedulerWrapper.registerCalledIdentifiers.count).to(equal(0))
            }
            
            it("with permittedIdentifiers and orchestrator.canRegisterTask is false") {
                let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"]))
                TestBGTaskOrchestrator.canRegisterTask = false
                
                let expression = {
                    _ = BGFrameworkCentralManager(
                        registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: []),
                        configurationProvidable: configurationProvider,
                        moc: self.coreDataManager.newBackgroundContext,
                        bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                        orchestrator: TestBGTaskOrchestrator.self,
                        scheduler: TestTaskScheduler.self,
                        bgTaskProcessControllerType: TestBGTaskProcessController.self,
                        notificationCenter: self.mockNotificationCenter
                    )
                }
                
                expecting(expression: expression).to(throwAssertion())
            }
            
            it("with permittedIdentifiers and orchestrator.canRegisterTask is true") {
                let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [.appRefreshTask: "com.phonepe.apprefresh"]))
                TestBGTaskOrchestrator.canRegisterTask = true
                
                _ = BGFrameworkCentralManager(
                    registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: []),
                    configurationProvidable: configurationProvider,
                    moc: self.coreDataManager.newBackgroundContext,
                    bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                    orchestrator: TestBGTaskOrchestrator.self,
                    scheduler: TestTaskScheduler.self,
                    bgTaskProcessControllerType: TestBGTaskProcessController.self,
                    notificationCenter: self.mockNotificationCenter
                )
                
                expecting(TestBGTaskSchedulerWrapper.registerCalledIdentifiers.count).to(equal(1))
            }
        }
    }
}

// MARK: - taskHandler method tests
extension BGFrameworkCentralManagerTests {
    
    private func taskHandlerTests() {
        context("taskHandler method tests") {
            
            self.taskExpiringTestCases()
            self.taskFinishedProcessingFullyTestCases()
        }
    }
    
    private func taskExpiringTestCases() {
        context("task expiring") {
            it("appRefreshTask") {
                self.testTaskExpiry(scheduletype: .appRefreshTask,
                               expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithConnectvityWithExternalPower") {
                self.testTaskExpiry(scheduletype: .processingTaskWithConnectivityWithExternalPower,
                               expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithConnectvityWithoutExternalPower") {
                self.testTaskExpiry(scheduletype: .processingTaskWithConnectivityWithoutExternalPower,
                               expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithoutConnectvity") {
                self.testTaskExpiry(scheduletype: .processingTaskWithoutConnectivity,
                               expectedCategoriesToProcess: [.withoutConnectivityTasks])
            }
        }
    }
    
    private func testTaskExpiry(scheduletype: BGTaskSchedulerType,
                                expectedCategoriesToProcess: [Constants.TaskCategory],
                                function: StaticString = #function,
                                line: UInt = #line) {
        let description = testFunctionDescription(function: function, line: line)
        
        waitUntil(timeout: testTimeout) { done in
            let taskId = "com.phonepe.\(scheduletype)"
            
            let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [scheduletype: taskId]))
            TestBGTaskOrchestrator.canRegisterTask = true
            
            let syncItem1 = BGSyncRegistrationData(identifier: "id_1") { compl in
                compl(true)
            }
            _ = BGFrameworkCentralManager(
                registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: [syncItem1]),
                configurationProvidable: configurationProvider,
                moc: self.coreDataManager.newBackgroundContext,
                bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                orchestrator: TestBGTaskOrchestrator.self,
                scheduler: TestTaskScheduler.self,
                bgTaskProcessControllerType: TestBGTaskProcessController.self,
                notificationCenter: self.mockNotificationCenter
            )
            
            expecting(TestBGTaskSchedulerWrapper.registerCalledIdentifiers.count).to(equal(1))
            
            expecting(TestBGTaskProcessController.initCalled).to(equal(false))
            expecting(TestBGTaskProcessController.processMethodCalled).to(equal(false))
            
            //Launching the background task
            TestBGTaskSchedulerWrapper.launchFor(identifier: taskId, type: scheduletype.taskType, callExpiration: 3)
            
            expecting(TestBGTaskProcessController.initCalled).to(equal(true))
            expecting(TestBGTaskProcessController.initMethodCategories).to(equal(expectedCategoriesToProcess))
            expecting(TestBGTask.didExpirationHandlerSet).to(equal(true))
            expecting(TestBGTaskProcessController.processMethodCalled).to(equal(true), description: description)
            
            performWith(delay: 4) {
                expecting(TestBGTaskProcessController.stopProcessingMethodCalled).to(equal(true))
                expecting(TestBGTask.setTaskCompletedMethodCalled).to(equal(true))
                expecting(TestBGTask.taskStatus).to(equal(true))
                
                done()
            }
        }
    }
    
    private func taskFinishedProcessingFullyTestCases() {
        context("task finished processing fully") {
            it("appRefreshTask") {
                self.testTaskFinishedProcessingFully(scheduletype: .appRefreshTask, expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithConnectvityWithExternalPower") {
                self.testTaskFinishedProcessingFully(scheduletype: .processingTaskWithConnectivityWithExternalPower, expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithConnectvityWithoutExternalPower") {
                self.testTaskFinishedProcessingFully(scheduletype: .processingTaskWithConnectivityWithoutExternalPower, expectedCategoriesToProcess: [.connectivityTasks, .withoutConnectivityTasks])
            }
            
            it("processingTaskWithoutConnectvity") {
                self.testTaskFinishedProcessingFully(scheduletype: .processingTaskWithoutConnectivity, expectedCategoriesToProcess: [.withoutConnectivityTasks])
            }
        }
    }
    
    private func testTaskFinishedProcessingFully(scheduletype: BGTaskSchedulerType,
                                                 expectedCategoriesToProcess: [Constants.TaskCategory]) {
        waitUntil(timeout: testTimeout) { done in
            let taskId = "com.phonepe.\(scheduletype)"
            
            let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [scheduletype: taskId]))
            TestBGTaskOrchestrator.canRegisterTask = true
            
            let syncItem1 = BGSyncRegistrationData(identifier: "id_1") { compl in
                compl(true)
            }
            _ = BGFrameworkCentralManager(
                registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: [syncItem1]),
                configurationProvidable: configurationProvider,
                moc: self.coreDataManager.newBackgroundContext,
                bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                orchestrator: TestBGTaskOrchestrator.self,
                scheduler: TestTaskScheduler.self,
                bgTaskProcessControllerType: TestBGTaskProcessController.self,
                notificationCenter: self.mockNotificationCenter
            )
            
            expecting(TestBGTaskSchedulerWrapper.registerCalledIdentifiers.count).to(equal(1))
            
            expecting(TestBGTaskProcessController.initCalled).to(equal(false))
            expecting(TestBGTaskProcessController.processMethodCalled).to(equal(false))
            
            //Launching the background task
            TestBGTaskSchedulerWrapper.launchFor(identifier: taskId, type: scheduletype.taskType)
            
            expecting(TestBGTaskProcessController.initCalled).to(equal(true))
            expecting(TestBGTaskProcessController.initMethodCategories).to(equal(expectedCategoriesToProcess))
            expecting(TestBGTask.didExpirationHandlerSet).to(equal(true))
            expecting(TestBGTaskProcessController.processMethodCalled).to(equal(true))
            
            performWith(delay: 3) {
                TestBGTaskProcessController.callCompletion()
                
                expecting(TestBGTask.setTaskCompletedMethodCalled).to(equal(true))
                expecting(TestBGTask.taskStatus).to(equal(true))
                
                done()
            }
        }
    }
}

// MARK: - appDidEnterBackground tests
extension BGFrameworkCentralManagerTests {
    private func appDidEnterBackgroundTest() {
        it("scheduleRequiredTasks method tests") {
            waitUntil(timeout: testTimeout) { done in
                let configurationProvider = TestBGConfigurationProvider(registrationData: BGConfigurationProvider.RegistrationData(permittedIdentifiers: [:]))
                let controller = BGFrameworkCentralManager(
                    registrationDataController: TestBGSyncItemRegistrationData(registeredUsecases: []),
                    configurationProvidable: configurationProvider,
                    moc: self.coreDataManager.newBackgroundContext,
                    bgTaskScheduleWrapper: TestBGTaskSchedulerWrapper.self,
                    orchestrator: TestBGTaskOrchestrator.self,
                    scheduler: TestTaskScheduler.self,
                    bgTaskProcessControllerType: TestBGTaskProcessController.self,
                    notificationCenter: self.mockNotificationCenter
                )
                
                expecting(TestTaskScheduler.scheduleRequiredTasksMethodCalled).to(equal(false))
                
                self.mockNotificationCenter.post(name: UIApplication.didEnterBackgroundNotification, object: nil)
                performWith(delay: 1) {
                    _ = controller //Need to capture 'controller' in this clouser. Otherwise test fails(Probably the object gets deallocated if we don't capture)
                    expecting(TestTaskScheduler.scheduleRequiredTasksMethodCalled).to(equal(true))
                    done()
                }
            }
        }
    }
}

extension BGFrameworkCentralManagerTests {
    
    class TestBGTaskOrchestrator: BGTaskOrchestratorProtocol {
        static func resetTestData() {
            canRegisterTask = true
        }
        
        static var canRegisterTask: Bool = true
        
        static func canRegisterTask(identifier: String, bundle: BundleHelper.Type) -> Bool {
            return canRegisterTask
        }
        
        func canSchedule(for type: BGTaskSchedulerType, identifier: String, bundle: BundleHelper.Type) -> Bool {
            return true
        }
        
        let registeredUsecases: [BGSyncRegistrationData]
        
        required init(registeredUsecases: [BGSyncRegistrationData],
                      bgRefreshStatusAvailability: BGRefreshStatusAvailability.Type) {
            self.registeredUsecases = registeredUsecases
        }
    }
    
    class TestTaskScheduler: TaskSchedulerProtocol {
        
        static func resetTestData() {
            scheduleRequiredTasksMethodCalled = false
        }
        
        static var scheduleRequiredTasksMethodCalled = false
        
        required init(configProvidable: BGConfigurationProvidable,
                      bgTaskScheduleWrapper: BGTaskSchedulerWrapperProtocol.Type,
                      orchestrator: BGTaskOrchestratorProtocol,
                      logger: BGLogger) {
        }
        
        func scheduleRequiredTasks(completion: @escaping () -> Void) {
            Self.scheduleRequiredTasksMethodCalled = true
            completion()
        }
        
        func cancelAllTaskRequests() {
        }
    }
    
    class TestBGTaskProcessController: BGTaskProcessControllerProtocol {
        
        required init(categories: [Constants.TaskCategory],
                      registrationDataController: BGSyncItemRegistrationDataProtocol,
                      configuration: BGConfigurationProvider.RegistrationData,
                      moc: NSManagedObjectContext,
                      logger: BGLogger,
                      taskData: BGTaskData) {
            Self.initCalled = true
            Self.initMethodCategories = categories
        }
        
        func process(completion: @escaping () -> Void) {
            Self.processCompletion = completion
            Self.processMethodCalled = true
        }
        
        func stopProcessing() {
            Self.stopProcessingMethodCalled = true
        }
        
        static func resetTestData() {
            initCalled = false
            initMethodCategories = []
            processMethodCalled = false
            stopProcessingMethodCalled = false
            processCompletion = nil
        }
        
        static var initCalled = false
        static var initMethodCategories: [Constants.TaskCategory] = []
        
        static var processMethodCalled: Bool = false
        static var stopProcessingMethodCalled: Bool = false
        static var processCompletion: (() -> Void)?
        
        static func callCompletion() {
            processCompletion?()
        }
    }
}
