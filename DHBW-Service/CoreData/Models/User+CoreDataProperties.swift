//
//  User+CoreDataProperties.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var course: String?
    @NSManaged public var director: String?
    @NSManaged public var name: String?

}

extension User : Identifiable {

}
