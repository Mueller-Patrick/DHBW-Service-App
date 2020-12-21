//
//  FirstOpeningSettings.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 21.12.20.
//

import SwiftUI
import CoreData

struct FirstOpeningSettings: View {
    @EnvironmentObject var settings: LocalSettings
    @State private var name = ""
    @State private var course = ""
    @State private var director = ""
    
    var body: some View {
        
        VStack {
            TextField("Name", text: self.$name)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            TextField("Course", text: self.$course)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            TextField("Director", text: self.$director)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            Button(action: {
                self.settings.isFirstOpening = !self.settings.isFirstOpening
            }){
                Text("Confirm")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
        }
    }
}

extension FirstOpeningSettings{
    func saveToCoreData(){
        let entity = NSEntityDescription.entity(forEntityName: "User", in: PersistenceController.shared.context)!
        let user = NSManagedObject(entity: entity, insertInto: PersistenceController.shared.context)
        user.setValue(name, forKey: "name")
        user.setValue(course, forKey: "course")
        user.setValue(director, forKey: "director")
        
        PersistenceController.shared.save()
    }
}

struct FirstOpeningSettings_Previews: PreviewProvider {
    static var previews: some View {
        FirstOpeningSettings()
            .preferredColorScheme(.dark)
            .environmentObject(LocalSettings())
    }
}
