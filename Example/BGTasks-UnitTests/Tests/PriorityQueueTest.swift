//
//  PriorityQueueTest.swift
//  BGTasks-ExampleTests
//
//  Created by Shridhara V on 08/11/21.
//

import XCTest
import Nimble
import Quick
@testable import BGTasks
import Senpai

class PriorityQueueTest: QuickSpec {
    
    override func spec() {
        
        describe("PriorityQueueTest Tests") {
            beforeEach {
                self.beforeEachTestSetup()
            }
            
            it("all eligible and without past history") {
                let moc = self.coreDataManager.newBackgroundContext
                moc.performAndWait {
                    var registedItems = [BGSyncRegistrationData]()
                    
                    //A: everyTime :: with connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "A",
                                                                configuration: .init(strategy: .everyTime,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    
                    //B: every24Hours :: with connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "B",
                                                                configuration: .init(strategy: .every24Hours,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    
                    //C: every4Hours :: without connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "C",
                                                                configuration: .init(strategy: .every4Hours,
                                                                                     requiresNetworkConnectivity: false),
                                                                handler: { completion in
                        
                    }))
                    
                    //D: every12Hours :: without connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "D",
                                                                configuration: .init(strategy: .every12Hours,
                                                                                     requiresNetworkConnectivity: false),
                                                                handler: { completion in
                        
                    }))
                    
                    try? moc.saveIfNeeded()
                    
                    let queue = PriorityQueue(registedItems: registedItems, moc: moc)
                    let tasks = queue.getTasks(categories: Constants.TaskCategory.allCases)
                    expecting(tasks.count).to(equal(4))
                    expecting(tasks[0].identifier).to(equal("A"))
                    expecting(tasks[1].identifier).to(equal("B"))
                    expecting(tasks[2].identifier).to(equal("C"))
                    expecting(tasks[3].identifier).to(equal("D"))
                }
            }
            
            it("not eligible ites") {
                let moc = self.coreDataManager.newBackgroundContext
                moc.performAndWait {
                    var registedItems = [BGSyncRegistrationData]()
                    
                    //A: everyTime :: with connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "A",
                                                                configuration: .init(strategy: .everyTime,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    
                    //B: every24Hours :: with connectivity
                    registedItems.append(BGSyncRegistrationData(identifier: "B",
                                                                configuration: .init(strategy: .every24Hours,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    
                    try? moc.saveIfNeeded()
                    
                    let queue = PriorityQueue(registedItems: registedItems, moc: moc)
                    let tasks = queue.getTasks(categories: [Constants.TaskCategory.withoutConnectivityTasks])
                    expecting(tasks.count).to(equal(0))
                }
            }
            
            it("all-types") {
                let moc = self.coreDataManager.newBackgroundContext
                moc.performAndWait {
                    var registedItems = [BGSyncRegistrationData]()
                    
                    //A: everyTime :: Eligible
                    registedItems.append(BGSyncRegistrationData(identifier: "A",
                                                                configuration: .init(strategy: .everyTime,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    let syncItemA = CDSyncItemUtil.findOrCreate(for: "A", moc: moc, saveIfNeeded: false)
                    syncItemA.lastSyncTime = Int64(Date().timeIntervalSince1970 - 100)
                    
                    //B: every24Hours & without past history :: Eligible
                    registedItems.append(BGSyncRegistrationData(identifier: "B",
                                                                configuration: .init(strategy: .every24Hours,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    
                    //C: every4Hours :: Eligible
                    registedItems.append(BGSyncRegistrationData(identifier: "C",
                                                                configuration: .init(strategy: .every4Hours,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    let syncItemC = CDSyncItemUtil.findOrCreate(for: "C", moc: moc, saveIfNeeded: false)
                    syncItemC.lastSyncTime = Int64(Date().timeIntervalSince1970 - secondsFor(hours: 5))
                    
                    //D: every12Hours :: Not eligible
                    registedItems.append(BGSyncRegistrationData(identifier: "D",
                                                                configuration: .init(strategy: .every12Hours,
                                                                                     requiresNetworkConnectivity: true),
                                                                handler: { completion in
                        
                    }))
                    let syncItemD = CDSyncItemUtil.findOrCreate(for: "D", moc: moc, saveIfNeeded: false)
                    syncItemD.lastSyncTime = Int64(Date().timeIntervalSince1970 - secondsFor(hours: 6))
                    
                    
                    //Z: everyTime but without connectivity :: Not eligible
                    registedItems.append(BGSyncRegistrationData(identifier: "Z",
                                                                configuration: .init(strategy: .everyTime,
                                                                                     requiresNetworkConnectivity: false),
                                                                handler: { completion in
                        
                    }))
                    let syncItemZ = CDSyncItemUtil.findOrCreate(for: "Z", moc: moc, saveIfNeeded: false)
                    syncItemZ.lastSyncTime = Int64(Date().timeIntervalSince1970 - secondsFor(hours: 3))
                    
                    try? moc.saveIfNeeded()
                    
                    let queue = PriorityQueue(registedItems: registedItems, moc: moc)
                    let tasks = queue.getTasks(categories: [Constants.TaskCategory.connectivityTasks])
                    expecting(tasks.count).to(equal(3))
                    expecting(tasks[0].identifier).to(equal("B"))
                    expecting(tasks[1].identifier).to(equal("C"))
                    expecting(tasks[2].identifier).to(equal("A"))
                }
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
