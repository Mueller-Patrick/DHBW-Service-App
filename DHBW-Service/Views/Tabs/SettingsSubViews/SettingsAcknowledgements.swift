//
//  SettingsAcknowledgements.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 28.12.20.
//

import SwiftUI

struct SettingsAcknowledgements: View {
    var body: some View {
        VStack {
            Text("Contributors")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("David Huh")
            Text("Patrick Müller")
            Spacer()
        }
    }
}

struct SettingsAcknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAcknowledgements()
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
