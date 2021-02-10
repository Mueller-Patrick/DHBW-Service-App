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
}
