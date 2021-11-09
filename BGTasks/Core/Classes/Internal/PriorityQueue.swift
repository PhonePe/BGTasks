//
//  PriorityQueue.swift
//  BGFramework
//
//  Created by Shridhara V on 17/03/21.
//

import Foundation
import CoreData

protocol PriorityTasksQueueProtocol {
    init(registedItems: [BGSyncRegistrationData], moc: NSManagedObjectContext)
}

class PriorityQueue {
    
    init(registedItems: [BGSyncRegistrationData], moc: NSManagedObjectContext) {
        self.registedItems = registedItems
        self.moc = moc
    }
    
    func getTasks(categories: [Constants.TaskCategory]) -> [BGSyncRegistrationData] {
        guard !self.registedItems.isEmpty else {
            return []
        }
        
        var prioritySyncItems = [BGSyncRegistrationData]()
        
        moc.performAndWait {
            
            for category in categories {
                let categoryItems = registedItems.filter { $0.configuration.requiresNetworkConnectivity == category.requiresNetworkConnectivity }
                guard !categoryItems.isEmpty else {
                    continue
                }
                
                var dbSyncItems = CDSyncItemUtil.getObjects(for: categoryItems, moc: moc)

#if DEBUG
                dbSyncItems.forEach { debugLog("identifier: \(String(describing: $0.cdSyncItem.identifier)), lastSyncTime: \($0.cdSyncItem.lastSyncTime)") }
#endif
                
                dbSyncItems = dbSyncItems.filter {
                    return $0.registrationData.configuration.strategy.isItEligible(lastSyncTime: TimeInterval($0.cdSyncItem.lastSyncTime))
                }
                
                dbSyncItems = dbSyncItems.sorted {
                    return $0.cdSyncItem.lastSyncTime < $1.cdSyncItem.lastSyncTime
                }
                
#if DEBUG
                debugLog("After filter & sort")
                dbSyncItems.forEach { debugLog("identifier: \(String(describing: $0.cdSyncItem.identifier)), lastSyncTime: \($0.cdSyncItem.lastSyncTime)") }
#endif
                
                
                prioritySyncItems.append(contentsOf: dbSyncItems.map { $0.registrationData })
            }
        }
        
        return prioritySyncItems
    }
    
    private let registedItems: [BGSyncRegistrationData]
    private let moc: NSManagedObjectContext
}
