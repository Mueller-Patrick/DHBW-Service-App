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
    @State var user: NSManagedObject = NSManagedObject()
    
    
    
    
    var body: some View {
        VStack {
            Button(action: {
                self.settings.isFirstOpening = !self.settings.isFirstOpening
            }){
                Text("First opening toggle")
            }
            Text("Test")
            
//            Text(user.value(forKey: "name") as! String)
            
        }.onAppear{
            self.readFromCoreData()
        }
    }
}

extension HomeView{
    func readFromCoreData(){
        let managedContext = PersistenceController.shared.context
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            try print(managedContext.fetch(fetchRequest))
            self.user = try managedContext.fetch(fetchRequest)[0]
        } catch let error as NSError {
            print(error)
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
