//
//  BGFrameworkCoreDataStack.swift
//  BGFramework
//
//  Created by Shridhara V on 24/03/21.
//

import Foundation
import CoreData

protocol CoreDataStackProvider {
    var mainContext: NSManagedObjectContext { get }
    var newBackgroundContext: NSManagedObjectContext { get }
}

final class BGFrameworkCoreDataStack: CoreDataStackProvider {
    
    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    var newBackgroundContext: NSManagedObjectContext {
        let moc = persistentContainer.newBackgroundContext()
        moc.automaticallyMergesChangesFromParent = true
        moc.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
        return moc
    }
    
    init() {
        persistentContainer = BGPersistantContainer()
        
        loadPersistentStores()
        
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
    }
    
    private let persistentContainer: BGPersistantContainer
    public let saveBubbleDispatchGroup = DispatchGroup()
}

extension BGFrameworkCoreDataStack {
    
    private func loadPersistentStores() {
        persistentContainer.loadPersistentStores {
            _, error in
            if let error = error as NSError? {
                #if DEBUG
                fatalError("Unresolved error \(error), \(error.userInfo)")
                #endif
            }
        }
    }
}

final private class BGPersistantContainer: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        guard let dbDirectory = FileManager.dbDirectory() else {
            return URL(fileURLWithPath: "")
        }
        
        let dbPath = (dbDirectory as NSString).appendingPathComponent("BGFrameworkDataStore")
        FileManager.createDirectoryIfRequired(path: dbPath)
        
        #if DEBUG
        debugLog("BGFrameworkDataStore DB Path: " + dbPath)
        #endif
        
        return URL(fileURLWithPath: dbPath)
    }
    
    init() {
        super.init(name: "BGFrameworkDataModel", managedObjectModel: BGPersistantContainer.managedObjectModel())
    }
    
    private class func managedObjectModel() -> NSManagedObjectModel {
        let bundle = Bundle.frameworkBundle()
        guard let url = bundle.url(forResource: "BGFrameworkDataModel", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: url) else {
                preconditionFailure("BGFrameworkDataModel model not found or corrupted")
        }
        return model
    }
}
