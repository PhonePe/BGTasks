//
//  CDSyncItem+CoreDataProperties.swift
//  
//
//  Created by Shridhara V on 17/03/21.
//
//

import Foundation
import CoreData


extension CDSyncItem {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDSyncItem> {
        return NSFetchRequest<CDSyncItem>(entityName: "CDSyncItem")
    }

    @NSManaged var identifier: String?
    @NSManaged var lastSyncTime: Int64
    @NSManaged var history: NSSet?

}

// MARK: Generated accessors for history
extension CDSyncItem {

    @objc(addHistoryObject:)
    @NSManaged func addToHistory(_ value: CDHistory)

    @objc(removeHistoryObject:)
    @NSManaged func removeFromHistory(_ value: CDHistory)

    @objc(addHistory:)
    @NSManaged func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged func removeFromHistory(_ values: NSSet)

}
