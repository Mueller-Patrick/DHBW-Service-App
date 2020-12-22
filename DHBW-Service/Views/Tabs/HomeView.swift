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
    @State private var course: String = ""
    @State private var director: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                self.settings.isFirstOpening = !self.settings.isFirstOpening
            }){
                Text("First opening toggle")
            }
            Text("Test")
            
            HStack {
                Text("name".localized(tableName: "General", plural: false) + ": ")
                Text(self.name)
            }
            HStack {
                Text("course".localized(tableName: "General", plural: false) + ": ")
                Text(self.course)
            }
            HStack {
                Text("director".localized(tableName: "General", plural: false) + ": ")
                Text(self.director)
            }
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
            self.course = user.value(forKey: "course") as! String
            self.director = user.value(forKey: "director") as! String
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
