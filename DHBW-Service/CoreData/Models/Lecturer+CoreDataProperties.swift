//
//  Lecturer+CoreDataProperties.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData


extension Lecturer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lecturer> {
        return NSFetchRequest<Lecturer>(entityName: "Lecturer")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var event: RaPlaEvent?

}

extension Lecturer : Identifiable {

}
