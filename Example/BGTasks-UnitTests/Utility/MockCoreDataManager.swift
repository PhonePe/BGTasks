//
//  MockCoreDataManager.swift
//  BGFramework_Tests
//
//  Created by Shridhara V on 02/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreData

public class MockCoreDataManager {
    public var mainContext: NSManagedObjectContext {
        return mockPersistantContainer.viewContext
    }
    
    public var newBackgroundContext: NSManagedObjectContext {
        let backgroundContext = mockPersistantContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        return backgroundContext
    }
    
    public init(bundles: [Bundle]) {
        self.bundles = bundles
    }
    
    // MARK: mock in-memory persistant store
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: self.bundles) else {
            return NSManagedObjectModel()
        }
        return managedObjectModel
    }()
    
    private lazy var mockPersistantContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MockCoreDataManager", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            // Check if the data store is in memory
            precondition( description.type == NSInMemoryStoreType )

            // Check if creating container wrong
            if let error = error {
                fatalError("Create an in-mem coordinator failed \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
        return container
    }()
    
    private let bundles: [Bundle]
}
