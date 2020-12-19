//
//  DHBW_ServiceApp.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 20.12.20.
//

import SwiftUI

@main
struct DHBW_ServiceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
