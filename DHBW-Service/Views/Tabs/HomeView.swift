//
//  HomeView.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 21.12.20.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @EnvironmentObject var settings: LocalSettings
    @State private var name: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                self.settings.isFirstOpening = !self.settings.isFirstOpening
            }){
                Text("First opening toggle")
            }
            Text("Test")
            
            Text(self.name)
            
        }.onAppear{
            self.readFromCoreData()
        }
    }
}

extension HomeView{
    func readFromCoreData() {
        let fetchedData = UtilityFunctions.getCoreDataObject(entity: "User")
        
        if(!fetchedData.isEmpty) {
            let user = fetchedData[0]
            self.name = user.value(forKey: "name") as! String
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
