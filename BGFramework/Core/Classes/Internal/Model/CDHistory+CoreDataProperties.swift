//
//  CDHistory+CoreDataProperties.swift
//  
//
//  Created by Shridhara V on 17/03/21.
//
//

import Foundation
import CoreData


extension CDHistory {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDHistory> {
        return NSFetchRequest<CDHistory>(entityName: "CDHistory")
    }

    @NSManaged var createdAt: Int64
    @NSManaged var timeTakenDuration: Int64
    @NSManaged var syncItem: CDSyncItem?

}
