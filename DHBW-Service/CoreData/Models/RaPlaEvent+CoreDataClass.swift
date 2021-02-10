//
//  RaPlaEvent+CoreDataClass.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData

@objc(RaPlaEvent)
public class RaPlaEvent: NSManagedObject {
    
    // MARK: Access methods
    @nonobjc public class func getAll() -> [RaPlaEvent] {
        let managedContext =
            PersistenceController.shared.context
        
        do {
            return try managedContext.fetch(RaPlaEvent.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    @nonobjc public class func getSpecified(sortDescriptors: [NSSortDescriptor] = [], searchPredicate: NSPredicate? = nil) -> [RaPlaEvent]{
        let managedContext =
            PersistenceController.shared.context
        
        let fetchRequest: NSFetchRequest = RaPlaEvent.fetchRequest()

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
    public var lecturerList: [Lecturer] {
        let set = lecturers as? Set<Lecturer> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
}
