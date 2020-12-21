//
//  HomeView.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 21.12.20.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var settings: LocalSettings
    
    var body: some View {
        VStack {
            Button(action: {
                self.settings.isFirstOpening = !self.settings.isFirstOpening
            }){
                Text("First opening toggle")
            }
            Text("Test")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
            .environmentObject(LocalSettings())
    }
}
