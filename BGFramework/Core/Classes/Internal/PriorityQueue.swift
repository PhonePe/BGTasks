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
        
        var prioritySyncItems = [BGSyncRegistrationData]()
        
        moc.performAndWait {
            
            for category in categories {
            
                let categoryItems = registedItems.filter { $0.configuration.requiresNetworkConnectivity == category.requiresNetworkConnectivity }
                let categoryItemIdentifiers = categoryItems.map { $0.identifier }
                
                var dbSyncItems = CDSyncItemUtil.getObjects(for: categoryItemIdentifiers, moc: moc)
                dbSyncItems.forEach { debugLog("identifier: \(String(describing: $0.identifier)), lastSyncTime: \($0.lastSyncTime)") }
                
                dbSyncItems.sort { $0.lastSyncTime < $1.lastSyncTime }
                debugLog("After sort")
                dbSyncItems.forEach { debugLog("identifier: \(String(describing: $0.identifier)), lastSyncTime: \($0.lastSyncTime)") }
                
                let sortedRegisteredItems = self.registedItems.filter { registeredSyncItem in
                    return dbSyncItems.contains(where: { $0.identifier == registeredSyncItem.identifier })
                }
                
                sortedRegisteredItems.forEach { debugLog("\($0)") }
                prioritySyncItems.append(contentsOf: sortedRegisteredItems)
            }
        }
        
        return prioritySyncItems
    }
    
    
    private let registedItems: [BGSyncRegistrationData]
    private let moc: NSManagedObjectContext
}
