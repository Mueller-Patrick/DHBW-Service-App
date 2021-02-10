//
//  RaPlaEvent+CoreDataProperties.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 10.02.21.
//
//

import Foundation
import CoreData


extension RaPlaEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RaPlaEvent> {
        return NSFetchRequest<RaPlaEvent>(entityName: "RaPlaEvent")
    }

    @NSManaged public var category: String?
    @NSManaged public var descr: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var isHidden: Bool
    @NSManaged public var location: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var summary: String?
    @NSManaged public var uid: String?
    @NSManaged public var lecturers: NSSet?

}

// MARK: Generated accessors for lecturers
extension RaPlaEvent {

    @objc(addLecturersObject:)
    @NSManaged public func addToLecturers(_ value: Lecturer)

    @objc(removeLecturersObject:)
    @NSManaged public func removeFromLecturers(_ value: Lecturer)

    @objc(addLecturers:)
    @NSManaged public func addToLecturers(_ values: NSSet)

    @objc(removeLecturers:)
    @NSManaged public func removeFromLecturers(_ values: NSSet)

}

extension RaPlaEvent : Identifiable {

}
