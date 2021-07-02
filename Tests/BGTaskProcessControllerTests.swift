//
//  BGTaskProcessControllerTests.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 17/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Nimble
import Quick
@testable import BGTasks

let testTimeout: TimeInterval = 20

class BGTaskProcessControllerTests: QuickSpec {
    
    override func spec() {
        guard #available(iOS 13.0, *) else {
            return
        }
        
        describe("BGTaskProcessController Tests") {
            beforeEach {
                self.beforeEachTestSetup()
            }
            
            it("inputs:registeredUsecases empty") {
                waitUntil(timeout: testTimeout) { done in
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.connectivityTasks, .withoutConnectivityTasks],
                                                                         registeredUsecases: [],
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.taskProcessController.process {
                        done()
                    }
                }
            }
            
            it("inputs:categories empty") {
                waitUntil(timeout: testTimeout) { done in
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: false)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(false))
                        self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                        done()
                    }
                }
            }
            
            it("inputs:categories empty and registeredUsecases empty") {
                waitUntil(timeout: testTimeout) { done in
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [],
                                                                         registeredUsecases: [],
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.taskProcessController.process {
                        done()
                    }
                }
            }
            
            it("inputs:categories=connectivityTasks,requiresNetworkConnectivity=false") {
                waitUntil(timeout: testTimeout) { done in
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: false)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.connectivityTasks],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(false))
                        self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                        done()
                    }
                }
            }
            
            it("inputs:categories=connectivityTasks,requiresNetworkConnectivity=true") {
                waitUntil(timeout: testTimeout) { done in
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: true)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.connectivityTasks],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(true))
                        
                        self.compareHistoryItemsFor(identifier: identifier1, count: 1)
                        
                        done()
                    }
                }
            }
            
            it("inputs:categories=connectivityTasks,requiresNetworkConnectivity_true=1,requiresNetworkConnectivity_false=1") {
                waitUntil(timeout: testTimeout) { done in
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: true)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    var usecase2Called = false
                    let identifier2 = "id_2"
                    let usecase2 = BGSyncRegistrationData(
                        identifier: identifier2, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: false)) { compl in
                        usecase2Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1, usecase2]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.connectivityTasks],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.compareHistoryItemsFor(identifier: identifier2, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(true))
                        expecting(usecase2Called).to(equal(false))
                        
                        self.compareHistoryItemsFor(identifier: identifier1, count: 1)
                        self.compareHistoryItemsFor(identifier: identifier2, count: 0)
                        done()
                    }
                }
            }
            
            it("inputs:categories=withoutConnectivityTasks,requiresNetworkConnectivity_true=1,requiresNetworkConnectivity_false=1") {
                waitUntil(timeout: testTimeout) { done in
                    
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: true)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    var usecase2Called = false
                    let identifier2 = "id_2"
                    let usecase2 = BGSyncRegistrationData(
                        identifier: identifier2, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: false)) { compl in
                        usecase2Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1, usecase2]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.withoutConnectivityTasks],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.compareHistoryItemsFor(identifier: identifier2, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(false))
                        expecting(usecase2Called).to(equal(true))
                        
                        self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                        self.compareHistoryItemsFor(identifier: identifier2, count: 1)
                        
                        done()
                    }
                }
            }
            
            it("inputs:categories=[connectivityTasks,withoutConnectivityTasks],requiresNetworkConnectivity_true=1,requiresNetworkConnectivity_false=1") {
                waitUntil(timeout: testTimeout) { done in
                    var usecase1Called = false
                    let identifier1 = "id_1"
                    let usecase1 = BGSyncRegistrationData(
                        identifier: identifier1, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: true)) { compl in
                        usecase1Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    var usecase2Called = false
                    let identifier2 = "id_2"
                    let usecase2 = BGSyncRegistrationData(
                        identifier: identifier2, configuration: BGSyncRegistrationData.Configuration(strategy: .everyTime,
                                                                                                requiresNetworkConnectivity: false)) { compl in
                        usecase2Called = true
                        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                            compl(true)
                        }
                    }
                    
                    let registeredUsecases = [usecase1, usecase2]
                    
                    let configuration = BGConfigurationProvider.RegistrationData(permittedIdentifiers: [BGTaskSchedulerType.appRefreshTask: "com.phonepe"])
                    self.taskProcessController = BGTaskProcessController(categories: [.connectivityTasks, .withoutConnectivityTasks],
                                                                         registeredUsecases: registeredUsecases,
                                                                         configuration: configuration,
                                                                         moc: self.coreDataManager.newBackgroundContext,
                                                                         logger: BGLoggerManager.shared,
                                                                         taskData: BGTaskData(taskUniqueId: "1234",
                                                                                              identifier: "com.phonepe",
                                                                                              taskType: .apprefresh))
                    self.compareHistoryItemsFor(identifier: identifier1, count: 0)
                    self.compareHistoryItemsFor(identifier: identifier2, count: 0)
                    self.taskProcessController.process {
                        expecting(usecase1Called).to(equal(true))
                        expecting(usecase2Called).to(equal(true))
                        
                        self.compareHistoryItemsFor(identifier: identifier1, count: 1)
                        self.compareHistoryItemsFor(identifier: identifier2, count: 1)
                        done()
                    }
                }
            }
        }
    }
    
    private func compareHistoryItemsFor(identifier: String, count: Int) {
        let moc = self.coreDataManager.newBackgroundContext
        moc.performAndWait {
            let predicate = NSPredicate(format: "%K = %@", #keyPath(CDSyncItem.identifier), identifier)
            if let syncItem1: CDSyncItem = moc.getObject(predicate: predicate) {
                expecting(syncItem1.history?.count).to(equal(count))
            }
        }
    }
    
    private func beforeEachTestSetup() {
        self.coreDataManager = MockCoreDataManager(bundles: [Bundle(for: CDHistory.self)])
        BGLoggerManager.shared.register(logger: logger)
    }
    
    //     swiftlint:disable implicitly_unwrapped_optional
    private var coreDataManager: MockCoreDataManager!
    private var taskProcessController: BGTaskProcessController!
    private let logger = TestLogger()
    // swiftlint:enable implicitly_unwrapped_optional
}
