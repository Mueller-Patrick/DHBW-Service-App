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
            Text("contributors".localized(tableName: "General", plural: false))
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("David Huh (davidhuh.de)")
            Text("Lisa Kletsko (li54.de)")
            Text("Patrick Müller (mueller-patrick.tech)")
            Spacer()
        }
    }
}

struct SettingsAcknowledgements_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAcknowledgements()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 12")
            .environmentObject(getFirstOpening())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
    
    static func getFirstOpening() -> LocalSettings {
        let settings = LocalSettings();
        settings.isFirstOpening = false;
        return settings
    }
}
