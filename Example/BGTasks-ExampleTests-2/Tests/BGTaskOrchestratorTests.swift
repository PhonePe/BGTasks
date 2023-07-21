//
//  BGTaskOrchestrator.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 18/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Quick
@testable import BGTasks

class BGTaskOrchestratorTests: QuickSpec {
    
    override func spec() {
        guard #available(iOS 13.0, *) else {
            return
        }
        
        describe("BGTaskOrchestrator Tests") {
            beforeEach {
                TestBundleHelper.permittedIds = []
                TestBGRefreshStatusAvailability.isAvailable = true
            }

            // MARK: - appRefreshTask
            context("appRefreshTask") {
                it("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("without permittedIdentifiers") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }

            // MARK: - processingTaskWithConnectvityWithExternalPower
            context("processingTaskWithConnectvityWithExternalPower") {
                it("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }

            // MARK: - processingTaskWithConnectvityWithoutExternalPower
            context("processingTaskWithConnectvityWithoutExternalPower") {
                it("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }

            // MARK: - processingTaskWithoutConnectvity
            context("processingTaskWithoutConnectvity") {
                it("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }

                it("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                it("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }

                    let registeredUsecases = [item1]
                    let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))

                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }
        }
        
        // MARK: - BGRefreshStatusAvailability Tests
        context("BGRefreshStatusAvailability Tests") {
            beforeEach {
                TestBundleHelper.permittedIds = []
                TestBGRefreshStatusAvailability.isAvailable = true
            }

            it("with enabled") {
                let item1 = BGSyncRegistrationData(
                    identifier: "item1",
                    configuration: .init(strategy: .everyTime,
                                         requiresNetworkConnectivity: true)) { compl in
                    compl(true)
                }
                
                let registeredUsecases = [item1]
                let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                let canSchedule = orchestrator.canSchedule(for: .appRefreshTask,
                                                           identifier: appRefreshTaskIdentifier,
                                                           bundle: TestBundleHelper.self)
                expecting(canSchedule).to(equal(true))
                
                let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                expecting(canRegister).to(equal(true))
            }
            
            it("with disabled") {
                let item1 = BGSyncRegistrationData(
                    identifier: "item1",
                    configuration: .init(strategy: .everyTime,
                                         requiresNetworkConnectivity: true)) { compl in
                    compl(true)
                }
                
                let registeredUsecases = [item1]
                let orchestrator = self.getBGTaskOrchestrator(registeredUsecases: registeredUsecases)
                let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                TestBGRefreshStatusAvailability.isAvailable = false
                let canSchedule = orchestrator.canSchedule(for: .appRefreshTask,
                                                           identifier: appRefreshTaskIdentifier,
                                                           bundle: TestBundleHelper.self)
                expecting(canSchedule).to(equal(false))
                
                let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                expecting(canRegister).to(equal(true))
            }
        }
    }
}

extension BGTaskOrchestratorTests {
    private func getBGTaskOrchestrator(registeredUsecases: [BGSyncRegistrationData]) -> BGTaskOrchestrator {
        return BGTaskOrchestrator(registeredUsecases: registeredUsecases,
                                  bgRefreshStatusAvailability: TestBGRefreshStatusAvailability.self)
    }
}

enum TestBundleHelper: BundleHelper {
    static var permittedIds: [String] = []
    static func permittedIdentifiers() -> [String] {
        return permittedIds
    }
}

enum TestBGRefreshStatusAvailability: BGRefreshStatusAvailability {
    static var isAvailable: Bool = true
}
