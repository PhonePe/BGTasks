//
//  CDHistory+Util.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation
import CoreData

final class CDHistoryUtil {
    
    static func addHistoryAndUpdateLastSyncTimeToSyncItem(identifier: String,
                                                          timeTakenDuration: TimeInterval,
                                                          moc: NSManagedObjectContext,
                                                          createdAt: Int64 = Int64(Date().timeIntervalSince1970)) {
        moc.performAndWait {
            let syncItem = CDSyncItemUtil.findOrCreate(for: identifier, moc: moc, saveIfNeeded: false)
            syncItem.updateLastSyncTime()
            
            let history = CDHistory(context: moc)
            history.createdAt = createdAt
            history.timeTakenDuration = Int64(timeTakenDuration)
            syncItem.addToHistory(history)
            
            do {
                try moc.saveIfNeeded()
            } catch {
                debugLog("Failed to save CDHistory. Error: \(error.localizedDescription)")
            }
        }
    }
    
    static func deletePastHistoryItemsUpto(createdAt: Int64, moc: NSManagedObjectContext, compl: (() -> Void)? = nil) {
        let predicate = NSPredicate(format: "%K <= %lld", #keyPath(CDHistory.createdAt), createdAt)
        moc.perform {
            let fetchRequest: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
            fetchRequest.predicate = predicate
            if let history = try? moc.fetch(fetchRequest) {
                history.forEach {
                    moc.delete($0)
                }
                try? moc.saveIfNeeded()
                compl?()
            }
        }
    }
}
