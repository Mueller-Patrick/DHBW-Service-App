//
//  SettingsMain.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 28.12.20.
//

import SwiftUI

struct SettingsMain: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SettingsMain_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMain()
            .preferredColorScheme(.dark)
            .environmentObject(getFirstOpening())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
    static func getFirstOpening() -> LocalSettings {
        let settings = LocalSettings();
        settings.isFirstOpening = false;
        return settings
    }
}
