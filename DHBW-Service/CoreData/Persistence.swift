//
//  Persistence.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 20.12.20.
//

import CoreData

struct PersistenceController {
    // Singleton
    static let shared = PersistenceController()

    // Cloud Kit container
    let container: NSPersistentCloudKitContainer
    
    // Managed object context
    public var context: NSManagedObjectContext {
        get {
            return self.container.viewContext
        }
    }

    // MARK: - Constructor
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "DHBW_Service")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    // MARK: - Core Data Saving support
    
    public func save() {
        if self.context.hasChanges {
            do {
                try self.context.save()
                print("In PersistenceController.shared.save()")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Preview content
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // set mock user
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: PersistenceController.shared.context)!
        let user = NSManagedObject(entity: userEntity, insertInto: PersistenceController.shared.context)
        user.setValue("Max Mustermann", forKey: "name")
        user.setValue("TINF19B4", forKey: "course")
        user.setValue("Dr. Mustermann", forKey: "director")
        
        // Generate mock events
        let eventEntity = NSEntityDescription.entity(forEntityName: "RaPlaEvent", in: PersistenceController.shared.context)!
        let normalEvent1 = NSManagedObject(entity: eventEntity, insertInto: PersistenceController.shared.context)
        let normalEvent2 = NSManagedObject(entity: eventEntity, insertInto: PersistenceController.shared.context)
        let examEvent = NSManagedObject(entity: eventEntity, insertInto: PersistenceController.shared.context)
        normalEvent1.setValue("Mock Event 1", forKey: "summary")
        normalEvent2.setValue("Mock Event 2", forKey: "summary")
        examEvent.setValue("Exam Event", forKey: "summary")
        normalEvent1.setValue("Mock Event 1 Description", forKey: "descr")
        normalEvent2.setValue("Mock Event 2 Description", forKey: "descr")
        examEvent.setValue("Exam Event Description", forKey: "descr")
        normalEvent1.setValue("E207 INF Hörsaal", forKey: "location")
        normalEvent2.setValue("A306 WI Hörsaal", forKey: "location")
        examEvent.setValue("Audimax A", forKey: "location")
        normalEvent1.setValue("Lehrveranstaltung", forKey: "category")
        normalEvent2.setValue("Lehrveranstaltung", forKey: "category")
        examEvent.setValue("Prüfung", forKey: "category")
        var currentDate = Date()
        currentDate.addTimeInterval(1*60*60);normalEvent1.setValue(currentDate, forKey: "startDate")
        currentDate.addTimeInterval(1*60*60);normalEvent2.setValue(currentDate, forKey: "startDate")
        currentDate.addTimeInterval(1*60*60);examEvent.setValue(currentDate, forKey: "startDate")
        currentDate.addTimeInterval(1*60*60);normalEvent1.setValue(currentDate, forKey: "endDate")
        currentDate.addTimeInterval(1*60*60);normalEvent2.setValue(currentDate, forKey: "endDate")
        currentDate.addTimeInterval(1*60*60);examEvent.setValue(currentDate, forKey: "endDate")
        normalEvent1.setValue("totalUniqueId1", forKey: "uid")
        normalEvent2.setValue("totalUniqueId2", forKey: "uid")
        examEvent.setValue("totalUniqueId3", forKey: "uid")
        
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
