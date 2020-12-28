//
//  UtilityFunctions.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 22.12.20.
//

import Foundation
import CoreData

class UtilityFunctions {
    public class func getCoreDataObject(entity: String) -> [NSManagedObject]{
        let managedContext =
            PersistenceController.shared.context
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: entity)
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    public class func deleteAllCoreDataEntitiesOfType(type: String) -> Bool{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: type)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try PersistenceController.shared.context.execute(deleteRequest)
            
            PersistenceController.shared.save()
            
            return true
        } catch let error as NSError {
            print(error)
            return false
        }
    }
    
    public class func deleteAllData() -> Bool {
        let entities = ["User", "Item"]
        var allSuccessful = true
        
        for entityName in entities {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try PersistenceController.shared.context.execute(deleteRequest)
                
                PersistenceController.shared.save()
            } catch let error as NSError {
                print(error)
                allSuccessful = false
            }
        }
        
        return allSuccessful
    }
}
