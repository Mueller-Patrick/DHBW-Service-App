//
//  FirstOpeningSettings.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 21.12.20.
//

import SwiftUI

struct FirstOpeningSettings: View {
    @EnvironmentObject var settings: LocalSettings
    
    var body: some View {
        Button(action: {
            self.settings.isFirstOpening = !self.settings.isFirstOpening
        }){
            Text("First opening toggle")
        }
    }
}

struct FirstOpeningSettings_Previews: PreviewProvider {
    static var previews: some View {
        FirstOpeningSettings()
    }
}
