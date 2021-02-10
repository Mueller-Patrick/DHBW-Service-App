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
}
