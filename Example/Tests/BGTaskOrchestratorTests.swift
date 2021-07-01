//
//  BGTaskOrchestrator.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 18/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Senpai
import Nimble
@testable import BGFramework
import CommonCodeUtility

class BGTaskOrchestratorTests: SenpaiSpecs {
    
    override func specs() {
        arena("BGTaskOrchestrator Tests") {
            beforeEachTest {
                TestBundleHelper.permittedIds = []
            }
            
            // MARK: - appRefreshTask
            scene("appRefreshTask") {
                test("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = [appRefreshTaskIdentifier]
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("without permittedIdentifiers") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let appRefreshTaskIdentifier = "com.phonepe.appreferesh"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .appRefreshTask, identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: appRefreshTaskIdentifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }
            
            // MARK: - processingTaskWithConnectvityWithExternalPower
            scene("processingTaskWithConnectvityWithExternalPower") {
                test("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }
            
            // MARK: - processingTaskWithConnectvityWithoutExternalPower
            scene("processingTaskWithConnectvityWithoutExternalPower") {
                test("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithConnectivityWithoutExternalPower, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }
            
            // MARK: - processingTaskWithoutConnectvity
            scene("processingTaskWithoutConnectvity") {
                test("with requiresNetworkConnectivity true") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("with requiresNetworkConnectivity false") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: false)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = [identifier]
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(true))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(true))
                }
                
                test("without permittedIds") {
                    let item1 = BGSyncRegistrationData(
                        identifier: "item1",
                        configuration: .init(strategy: .everyTime,
                                             requiresNetworkConnectivity: true)) { compl in
                        compl(true)
                    }
                    
                    let registeredUsecases = [item1]
                    let orchestrator = BGTaskOrchestrator(registeredUsecases: registeredUsecases)
                    let identifier = "com.phonepe.processing.task"
                    TestBundleHelper.permittedIds = []
                    let canSchedule = orchestrator.canSchedule(for: .processingTaskWithoutConnectivity, identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canSchedule).to(equal(false))
                    
                    let canRegister = BGTaskOrchestrator.canRegisterTask(identifier: identifier, bundle: TestBundleHelper.self)
                    expecting(canRegister).to(equal(false))
                }
            }
        }
    }
}

enum TestBundleHelper: BundleHelper {
    static var permittedIds: [String] = []
    static func permittedIdentifiers() -> [String] {
        return permittedIds
    }
}
