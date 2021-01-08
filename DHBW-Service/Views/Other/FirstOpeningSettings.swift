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
    @State private var invalidInputName = false
    @State private var invalidInputCourse = false
    
    var body: some View {
        VStack {
            Text("welcomeText".localized(tableName: "General", plural: false))
            
            TextField("name".localized(tableName: "General", plural: false), text: self.$name)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(invalidInputName ? Color.red : Color.secondary, lineWidth: 1))
                .foregroundColor(invalidInputName ? .red : .primary)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            
            TextField("course".localized(tableName: "General", plural: false), text: self.$course)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(invalidInputCourse ? Color.red : Color.secondary, lineWidth: 1))
                .onChange(of: course, perform: { value in
                    self.setDirector()
                })
                .foregroundColor(invalidInputCourse ? .red : .primary)
                .textContentType(.name)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            
            TextField("director".localized(tableName: "General", plural: false) + " (" +  "filledAuto".localized(tableName: "General", plural: false) + ")", text: self.$director)
                .foregroundColor(.primary)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
                .disabled(true)
            
            Button(action: {
                self.saveToCoreData()
                self.checkAppIcon()
            }){
                Text("Confirm")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            //.disabled() //TODO: Check all inputs before enabling the button
        }
    }
}

extension FirstOpeningSettings{
    func setDirector() {
        if (course == "TINF19B4") {
            director = "Jörn Eisenbiegler"
        } else {
            director = ""
        }
    }
    
    func checkInput() -> Bool {
        let nameRegex = try! NSRegularExpression(pattern: "[a-zA-ZÄÖÜäöüß]+")
        let courseRegex = try! NSRegularExpression(pattern: "[T|G|W][A-Z]{2,3}[0-9]{2}B[1-9]")
        let nameRange = NSRange(location: 0, length: name.utf16.count)
        let courseRange = NSRange(location: 0, length: course.utf16.count)
        
        invalidInputName = nameRegex.firstMatch(in: name, options: [], range: nameRange) == nil
        invalidInputCourse = courseRegex.firstMatch(in: course, options: [], range: courseRange) == nil
        
        return !invalidInputName && !invalidInputCourse
    }
    
    func saveToCoreData(){
        if (!self.checkInput()) {
            print("Input invalid")
            return
        }
        
        // Delete old user data
        let status = UtilityFunctions.deleteAllCoreDataEntitiesOfType(type: "User")
        print("Deleting old user data status: \(status)")
        
        // Insert new user data
        let entity = NSEntityDescription.entity(forEntityName: "User", in: PersistenceController.shared.context)!
        let user = NSManagedObject(entity: entity, insertInto: PersistenceController.shared.context)
        user.setValue(name, forKey: "name")
        user.setValue(course, forKey: "course")
        user.setValue(director, forKey: "director")
        
        self.settings.isFirstOpening = !self.settings.isFirstOpening
        PersistenceController.shared.save()
    }
    
    /*
     Check the input and change app icon if necessary
     */
    func checkAppIcon() {
        if(self.name.lowercased().contains("alpaca")) {
            UIApplication.shared.setAlternateIconName("Alpaca-Alt-Icon") { error in
                if let error = error {
                    print("Error changing app icon:")
                    print(error.localizedDescription)
                } else {
                    print("Successfully changed app icon!")
                }
            }
        }
        if(UIApplication.shared.alternateIconName == "Alpaca-Alt-Icon" && !self.name.lowercased().contains("alpaca")) {
            UIApplication.shared.setAlternateIconName(nil) { error in
                if let error = error {
                    print("Error changing app icon:")
                    print(error.localizedDescription)
                } else {
                    print("Successfully changed app icon!")
                }
            }
        }
    }
}

struct FirstOpeningSettings_Previews: PreviewProvider {
    static var previews: some View {
        FirstOpeningSettings()
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
