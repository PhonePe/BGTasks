//
//  NSManagedObjectContext+Ext.swift
//  BGFramework
//
//  Created by Shridhara V on 18/03/21.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveIfNeeded() throws {
        guard hasChanges else {
            return
        }
        
        try save()
    }
    
    func performAndWaitAndReturn<Return>(_ body: @escaping () -> Return) -> Return {
        // swiftlint:disable implicitly_unwrapped_optional
        var result: Return!
        
        performAndWait {
            result = body()
        }
        
        return result
        // swiftlint:enable implicitly_unwrapped_optional
    }
    
    func getObjects<T: NSManagedObject>(predicate: NSPredicate) -> [T]? {
        return self.performAndWaitAndReturn {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
            fetchRequest.predicate = predicate
            
            if let result = (try? self.fetch(fetchRequest)) as? [T] {
                return result
            }
            
            return nil
        }
    }
    
    func getObject<T: NSManagedObject>(predicate: NSPredicate) -> T? {
        let results: [T]? = getObjects(predicate: predicate)
        return results?.first
    }
}
