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
            if(!settings.isFirstOpening) {
                TabView(selection: $selection) {
                    HomeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        }
                        .tag(0)
                }
            } else {
                Button(action: {
                    self.settings.isFirstOpening = !self.settings.isFirstOpening
                }){
                    Text("First opening toggle")
                }
            }
        }
    }
}

extension ContentView{
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
