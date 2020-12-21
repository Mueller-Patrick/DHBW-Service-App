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
                print("In CoreData.stack.save()")
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
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
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
