//
//  CDSyncItem+Util.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation
import CoreData

final class CDSyncItemUtil {
    
    static func getObjects(for identifiers: [String], moc: NSManagedObjectContext) -> [CDSyncItem] {
        return moc.performAndWaitAndReturn {
            let syncItems = identifiers.map {
                return findOrCreate(for: $0, moc: moc, saveIfNeeded: false)
            }
            
            do {
                try moc.saveIfNeeded()
            } catch {
                debugLog("Failed to save. Error: \(error.localizedDescription)")
            }
            
            return syncItems
        }
    }
    
    /// Before returning, it creates and saves if one doesn't exist.
    static func findOrCreate(for identifier: String, moc: NSManagedObjectContext, saveIfNeeded: Bool) -> CDSyncItem {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDSyncItem.identifier), identifier)
        if let object: CDSyncItem = moc.getObject(predicate: predicate) {
            return object
        } else {
            let item = CDSyncItem(context: moc)
            item.identifier = identifier
            if saveIfNeeded {
                try? moc.saveIfNeeded()
            }
            return item
        }
    }
    
//    static func updateLastSyncTime(for identifiers: [String], moc: NSManagedObjectContext) {
//        moc.performAndWait {
//            let objects = getObjects(for: identifiers, moc: moc)
//            objects.forEach {
//                $0.updateLastSyncTime()
//            }
//            try? moc.saveIfNeeded()
//        }
//        
//    }
}

extension CDSyncItem {
    func updateLastSyncTime() {
        let currentTime = Int64(Date().timeIntervalSince1970)
        self.lastSyncTime = currentTime
    }
}
