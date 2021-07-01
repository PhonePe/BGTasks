//
//  CDHistoryUtil.swift
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

class CDHistoryUtilTests: SenpaiSpecs {
    
    override func specs() {
        arena("CDHistoryUtil Tests") {
            beforeEachTest {
                self.beforeEachTestSetup()
            }
            
            test("test addHistoryAndUpdateLastSyncTimeToSyncItem") {
                let identifier = "id1"
                
                self.compareHistoryItemsFor(identifier: identifier, count: 0)
                
                let count = 5
                for i in 1...count {
                    CDHistoryUtil.addHistoryAndUpdateLastSyncTimeToSyncItem(
                        identifier: identifier,
                        timeTakenDuration: TimeInterval(i),
                        moc: self.coreDataManager.newBackgroundContext
                    )
                }
                
                self.compareHistoryItemsFor(identifier: identifier, count: count)
            }
            
            test("test deletePastHistoryItemsUpto") {
                waitUntil(timeout: testTimeout) { done in
                    let identifier = "id1"
                    
                    self.compareHistoryItemsFor(identifier: identifier, count: 0)
                    
                    let secondsInDays: Int64 = 7 * 24 * 60 * 60
                    let expiryTime = Int64(Date().timeIntervalSince1970) - Int64(7 * secondsInDays)
                    
                    let expiredMessages: Int64 = 5
                    for i in 1...expiredMessages {
                        CDHistoryUtil.addHistoryAndUpdateLastSyncTimeToSyncItem(
                            identifier: identifier,
                            timeTakenDuration: TimeInterval(i),
                            moc: self.coreDataManager.newBackgroundContext,
                            createdAt: expiryTime - i * secondsInDays
                        )
                    }
                    
                    let nonExpiredMessages: Int64 = 5
                    for i in 1...nonExpiredMessages {
                        CDHistoryUtil.addHistoryAndUpdateLastSyncTimeToSyncItem(
                            identifier: identifier,
                            timeTakenDuration: TimeInterval(i),
                            moc: self.coreDataManager.newBackgroundContext,
                            createdAt: expiryTime + i * secondsInDays
                        )
                    }
                    
                    self.compareHistoryItemsFor(identifier: identifier, count: Int(expiredMessages + nonExpiredMessages))
                    
                    CDHistoryUtil.deletePastHistoryItemsUpto(createdAt: expiryTime, moc: self.coreDataManager.newBackgroundContext) {
                        self.compareHistoryItemsFor(identifier: identifier, count: Int(nonExpiredMessages))
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
            } else {
                //This added just to make sure the count is zero if the execution falls to this case.
                expecting(count).to(equal(0))
            }
        }
    }
    
    private func beforeEachTestSetup() {
        self.coreDataManager = MockCoreDataManager(bundles: [Bundle(for: CDHistory.self)])
    }
    
    //     swiftlint:disable implicitly_unwrapped_optional
    private var coreDataManager: MockCoreDataManager!
    private var taskProcessController: BGTaskProcessController!
    // swiftlint:enable implicitly_unwrapped_optional
}
