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
        let user = User(context: PersistenceController.shared.context)
        user.name = "Max Mustermann"
        user.course = "TINF19B4"
        user.director = "Prof. Dr. Mustermann"
        
        // Generate mock events
        let normalEvent1 = RaPlaEvent(context: PersistenceController.shared.context)
        let normalEvent2 = RaPlaEvent(context: PersistenceController.shared.context)
        let examEvent = RaPlaEvent(context: PersistenceController.shared.context)
        normalEvent1.summary = "Mock Event 1"
        normalEvent2.summary = "Mock Event 2"
        examEvent.summary = "Exam Event"
        
        normalEvent1.descr = "Mock Event 1 description"
        normalEvent2.descr = "Mock Event 2 description"
        examEvent.descr = "Exam Event description"
        
        normalEvent1.location = "E207 INF Hörsaal"
        normalEvent2.location = "A306 WI Hörsaal"
        examEvent.location = "Audimax A"
        
        normalEvent1.category = "Lehrveranstaltung"
        normalEvent2.category = "Lehrveranstaltung"
        examEvent.category = "Prüfung"
        
        
        let lecturer1 = Lecturer(context: PersistenceController.shared.context)
        let lecturer2 = Lecturer(context: PersistenceController.shared.context)
        lecturer1.name = "Mustermann, Prof. Dr."
        lecturer1.email = "mustermann@dhbw-karlsruhe.de"
        lecturer2.name = "Musterfrau, Prof. Dr."
        lecturer2.email = "musterfrau@dhbw-karlsruhe.de"
        normalEvent1.addToLecturers(lecturer1)
        normalEvent2.addToLecturers(lecturer2)
        examEvent.addToLecturers(lecturer1)
        examEvent.addToLecturers(lecturer2)
        
        var currentDate = Date()
        currentDate.addTimeInterval(1*60*60);normalEvent1.startDate = currentDate
        currentDate.addTimeInterval(1*60*60);normalEvent2.startDate = currentDate
        currentDate.addTimeInterval(1*60*60);examEvent.startDate = currentDate
        currentDate.addTimeInterval(1*60*60);normalEvent1.endDate = currentDate
        currentDate.addTimeInterval(1*60*60);normalEvent2.endDate = currentDate
        currentDate.addTimeInterval(1*60*60);examEvent.endDate = currentDate
        
        normalEvent1.uid = "totalUniqueId1"
        normalEvent2.uid = "totalUniqueId2"
        examEvent.uid = "totalUniqueId3"
        
        
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
