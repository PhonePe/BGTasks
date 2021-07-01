//
//  PPBGRegistrationControllerTests.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 20/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Senpai
import Nimble
@testable import BGFramework
import CommonCodeUtility
import BackgroundTasks
import ConfigManager

@available(iOS 13.0, *)
class PPBGRegistrationControllerTests: SenpaiSpecs {
    
    override func specs() {
        arena("PPBGRegistrationController Tests") {
            beforeEachTest {
                TestPPBGConfigProvidable.resetTestData()
                TestBGFrameworkFactory.registrationCntl.resetTestData()
                TestBGFrameworkFactory.resetTestData()
            }
            
            scene("registerSyncItem") {
                test("config disabled") {
                    let ppBGRegistrationController = PPBGRegistrationController(
                        config: TestPPBGConfigProvidable.self,
                        frameworkFactory: TestBGFrameworkFactory.self,
                        configManager: TestConfigManager()
                    )
                    ppBGRegistrationController.registerSyncItem(identifier: "id_!") { compl in
                        compl(true)
                    }
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.registerSyncItemMethodCalled).to(equal(false))
                }
                
                test("config enabled but tenantInfo is nil") {
                    TestPPBGConfigProvidable.enabled = true
                    
                    let ppBGRegistrationController = PPBGRegistrationController(
                        config: TestPPBGConfigProvidable.self,
                        frameworkFactory: TestBGFrameworkFactory.self,
                        configManager: TestConfigManager()
                    )
                    ppBGRegistrationController.registerSyncItem(identifier: "id_!") { compl in
                        compl(true)
                    }
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.registerSyncItemMethodCalled).to(equal(false))
                }
                
                test("all config enabled") {
                    let identifier = "id_1"
                    TestPPBGConfigProvidable.enabled = true
                    TestPPBGConfigProvidable.usecaseInfo = .init(
                        identifier: identifier,
                        strategy: .everyTime,
                        networkConnectivity: true
                    )
                    
                    let ppBGRegistrationController = PPBGRegistrationController(
                        config: TestPPBGConfigProvidable.self,
                        frameworkFactory: TestBGFrameworkFactory.self,
                        configManager: TestConfigManager()
                    )
                    ppBGRegistrationController.registerSyncItem(identifier: identifier) { compl in
                        compl(true)
                    }
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.registerSyncItemMethodCalled).to(equal(true))
                }
            }
            
            test("unRegisterSyncItem") {
                let identifier = "id_1"
                
                let ppBGRegistrationController = PPBGRegistrationController(
                    config: TestPPBGConfigProvidable.self,
                    frameworkFactory: TestBGFrameworkFactory.self,
                    configManager: TestConfigManager()
                )
                expecting(TestBGFrameworkFactory.registrationCntl.unRegisterSyncItemMethodCalled).to(equal(false))
                ppBGRegistrationController.unRegisterSyncItem(identifier)
                expecting(TestBGFrameworkFactory.registrationCntl.unRegisterSyncItemMethodCalled).to(equal(true))
            }
            
            test("resetAllSyncItems") {
                let ppBGRegistrationController = PPBGRegistrationController(
                    config: TestPPBGConfigProvidable.self,
                    frameworkFactory: TestBGFrameworkFactory.self,
                    configManager: TestConfigManager()
                )
                expecting(TestBGFrameworkFactory.registrationCntl.resetAllSyncItemsMethodCalled).to(equal(false))
                ppBGRegistrationController.resetAllSyncItems()
                expecting(TestBGFrameworkFactory.registrationCntl.resetAllSyncItemsMethodCalled).to(equal(true))
            }
            
            scene("config manager changes") {
                test("with kill switch enagaged") {
                    let identifier = "id_1"
                    TestPPBGConfigProvidable.enabled = true
                    TestPPBGConfigProvidable.usecaseInfo = .init(
                        identifier: identifier,
                        strategy: .everyTime,
                        networkConnectivity: true
                    )
                    
                    let configManager = TestConfigManager()
                    
                    let ppBGRegistrationController = PPBGRegistrationController(
                        config: TestPPBGConfigProvidable.self,
                        frameworkFactory: TestBGFrameworkFactory.self,
                        configManager: configManager
                    )
                    
                    ppBGRegistrationController.registerSyncItem(identifier: identifier) { compl in
                        compl(true)
                    }
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.registeredUsecases.count).to(equal(1))
                    expecting(TestBGFrameworkFactory.registrationCntl.registerSyncItemMethodCalled).to(equal(true))
                    
                    //this is kill switching
                    TestPPBGConfigProvidable.usecaseInfo = nil
                    
                    configManager.callListeners()
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.unRegisterSyncItemMethodCalled).to(equal(true))
                    expecting(TestBGFrameworkFactory.registrationCntl.registeredUsecases.count).to(equal(0))
                }
                
                test("without kill switch enagaged") {
                    let identifier = "id_1"
                    TestPPBGConfigProvidable.enabled = true
                    TestPPBGConfigProvidable.usecaseInfo = .init(
                        identifier: identifier,
                        strategy: .everyTime,
                        networkConnectivity: true
                    )
                    
                    let configManager = TestConfigManager()
                    
                    let ppBGRegistrationController = PPBGRegistrationController(
                        config: TestPPBGConfigProvidable.self,
                        frameworkFactory: TestBGFrameworkFactory.self,
                        configManager: configManager
                    )
                    
                    ppBGRegistrationController.registerSyncItem(identifier: identifier) { compl in
                        compl(true)
                    }
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.registeredUsecases.count).to(equal(1))
                    expecting(TestBGFrameworkFactory.registrationCntl.registerSyncItemMethodCalled).to(equal(true))
                    
                    //not kill switching
                    //                TestPPBGConfigProvidable.tenantInfo = nil
                    configManager.callListeners()
                    
                    expecting(TestBGFrameworkFactory.registrationCntl.unRegisterSyncItemMethodCalled).to(equal(false))
                    expecting(TestBGFrameworkFactory.registrationCntl.registeredUsecases.count).to(equal(1))
                }
            }
        }
    }
}

@available(iOS 13.0, *)
extension PPBGRegistrationControllerTests {
    
    class TestPPBGConfigProvidable: PPBGConfigProvidable {
        static var enabled: Bool = false
        
        static var configConstantValues: PPBGConfig.PPBGConfigConstantValues? {
            return .init(processingTaskScheduleInterval: 10,
                         appRefreshTaskScheduleInterval: 10,
                         historyDataTTLInDays: 10,
                         maxConcurrentSyncCount: 5)
        }
        
        static func usecaseInfoFor(identifier: String) -> PPBGConfig.UsecaseInfo? {
            return usecaseInfo
        }
        
        static func resetTestData() {
            usecaseInfo = nil
            enabled = false
        }
        
        static var usecaseInfo: PPBGConfig.UsecaseInfo?
    }

    class TestBGFrameworkFactory: BGFrameworkFactoryProtocol {
        static let registrationCntl = TestBGSyncRegistration()
        
        static func registrationController() -> BGSyncRegistrationProtocol {
            return registrationCntl
        }
        
        static func resetTestData() {
            registrationCntl.resetTestData()
        }
    }

    class TestBGSyncRegistration: BGSyncRegistrationProtocol {
        var registeredUsecases = [BGSyncRegistrationData]()
        
        func registerSyncItem(_ data: BGSyncRegistrationData) {
            registerSyncItemMethodCalled = true
            registeredUsecases.append(data)
        }
        
        func unRegisterSyncItem(_ identifier: String) {
            unRegisterSyncItemMethodCalled = true
            if let index = registeredUsecases.firstIndex(where: { $0.identifier == identifier }) {
                registeredUsecases.remove(at: index)
            }
        }
        
        func resetAllSyncItems() {
            resetAllSyncItemsMethodCalled = true
        }
        
        func resetTestData() {
            registerSyncItemMethodCalled = false
            unRegisterSyncItemMethodCalled = false
            resetAllSyncItemsMethodCalled = false
            registeredUsecases = []
        }
        
        var registerSyncItemMethodCalled = false
        var unRegisterSyncItemMethodCalled = false
        var resetAllSyncItemsMethodCalled = false
    }

    class TestConfigManager: ConfigManagerProtocol {
        func value(for keys: [String], requestModel: ConfigRequestModel, completion: @escaping ConfigResultCompletion) {
            completion(nil, nil, ConfigFetchResultMode.complete)
        }
        
        func value<T>(for root: String) -> T? where T: CMConfigModelType {
            return nil
        }
        
        func registerListener(id: String, changeListener: @escaping ConfigValueChange.Completion) {
            dict[id] = changeListener
        }
        
        func deregisterListener(id: String) {
            dict[id] = nil
        }
        
        var dict: [String: ConfigValueChange.Completion] = [:]
        
        func callListeners() {
            dict.forEach {
                $0.value([:])
            }
        }
        
        func resolveOnlineOrCache(key: String, completion: @escaping ([String: Any]?) -> Void) {
            completion([:])
        }
    }
}
