//
//  UtilityFunctions.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 22.12.20.
//

import Foundation
import CoreData

class UtilityFunctions {
    // DEPRECATED, replaced by the respective getSpecified() method of each CoreData object
    public class func getCoreDataObject(entity: String, sortDescriptors: [NSSortDescriptor] = [], searchPredicate: NSPredicate? = nil) -> [NSManagedObject]{
        let managedContext =
            PersistenceController.shared.context
        
        let fetchRequest =
          NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.sortDescriptors = sortDescriptors
        if(searchPredicate != nil) {
            fetchRequest.predicate = searchPredicate
        }
        
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
        let entities = ["User", "RaPlaEvent"]
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
    
    // MARK: Find matches in the given text for the given regex string.
    public class func regexMatches(for regex: String, with options: NSRegularExpression.Options, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex, options: options)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
