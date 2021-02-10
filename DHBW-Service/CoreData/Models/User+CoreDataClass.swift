//
//  User+CoreDataClass.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @nonobjc public class func getAll() -> [User] {
        let managedContext =
            PersistenceController.shared.context
        
        do {
            return try managedContext.fetch(User.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    @nonobjc public class func getSpecified(sortDescriptors: [NSSortDescriptor] = [], searchPredicate: NSPredicate? = nil) -> [User]{
        let managedContext =
            PersistenceController.shared.context
        
        let fetchRequest: NSFetchRequest = User.fetchRequest()

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
}
