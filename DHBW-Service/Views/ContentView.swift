//
//  ContentView.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 20.12.20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var settings: LocalSettings
    @State private var selection = 0
    
    var body: some View {
        Group {
            if(settings.isFirstOpening) {
                FirstOpeningSettings()
            } else {
                TabView(selection: $selection) {
                    HomeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        }
                        .tag(0)
                    HomeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }
                        .tag(1)
                }
            }
        }
    }
}

extension ContentView{
}

struct ContentView_Previews: PreviewProvider {
    
    static func getFirstOpening() -> LocalSettings {
        let settings = LocalSettings();
        settings.isFirstOpening = false;
        return settings
    }
    
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(getFirstOpening())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
