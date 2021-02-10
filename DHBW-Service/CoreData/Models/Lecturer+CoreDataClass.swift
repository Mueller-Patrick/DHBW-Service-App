//
//  Lecturer+CoreDataClass.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData

@objc(Lecturer)
public class Lecturer: NSManagedObject {
    // MARK: Access methods
    @nonobjc public class func getAll() -> [Lecturer] {
        let managedContext =
            PersistenceController.shared.context
        
        do {
            return try managedContext.fetch(Lecturer.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    @nonobjc public class func getSpecified(sortDescriptors: [NSSortDescriptor] = [], searchPredicate: NSPredicate? = nil) -> [Lecturer]{
        let managedContext =
            PersistenceController.shared.context
        
        let fetchRequest: NSFetchRequest = Lecturer.fetchRequest()

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
    
    // MARK: Wrappers
    public var wrappedName: String {
        name ?? ""
    }
    
    public var wrappedEmail: String {
        email ?? ""
    }
}
