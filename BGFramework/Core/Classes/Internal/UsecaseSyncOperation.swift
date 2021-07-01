//
//  UsecaseSyncOperation.swift
//  BGFramework
//
//  Created by Shridhara V on 25/03/21.
//

import Foundation
import CoreData

class UsecaseSyncOperation: Operation {
    
    init(syncData: BGSyncRegistrationData, moc: NSManagedObjectContext, logger: BGLogger, taskData: BGTaskData) {
        self.syncData = syncData
        self.moc = moc
        self.logger = logger
        self.taskData = taskData
        
        super.init()
    }
    
    override func main() {
        debugLog("UsecaseSyncOperation bagan: \(syncData.identifier)")
        
        guard !isCancelled else {
            return
        }
        
        logger.syncBegan(forUsecaseIdentifier: syncData.identifier, inBGTask: taskData)
        
        self.semaphore = DispatchSemaphore(value: 0)
        
        let startTime = Date()
        
        self.syncData.handler { [weak self] result in
            defer {
                self?.semaphore?.signal()
            }
            
            guard let safeSelf = self else {
                return
            }
            
            debugLog("UsecaseSyncOperation finished: \(safeSelf.syncData.identifier)")
            
            let timeTakenDuration = Date().timeIntervalSince(startTime)
            debugLog("timeTakenDuration: \(timeTakenDuration)")
            
            CDHistoryUtil.addHistoryAndUpdateLastSyncTimeToSyncItem(
                identifier: safeSelf.syncData.identifier,
                timeTakenDuration: timeTakenDuration,
                moc: safeSelf.moc
            )
            safeSelf.logger.syncEnded(
                forUsecaseIdentifier: safeSelf.syncData.identifier,
                result: UsecaseSyncResult(status: result,
                                          timeTakenDuration: timeTakenDuration),
                inBGTask: safeSelf.taskData
            )
        }
        
        self.semaphore?.wait()
    }
    
    private let syncData: BGSyncRegistrationData
    private let moc: NSManagedObjectContext
    private let logger: BGLogger
    private let taskData: BGTaskData
    private var semaphore: DispatchSemaphore?
}
