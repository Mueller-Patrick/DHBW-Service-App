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
    @State private var dhbwLocation = ""
    @State private var course = ""
    @State private var director = ""
    @State private var raplaLink = ""
    @State private var invalidInputName = false
    @State private var invalidInputCourse = false
    
    var body: some View {
        VStack {
            Text("welcomeText".localized(tableName: "General"))
            
            TextField("name".localized(tableName: "General"), text: self.$name)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(invalidInputName ? Color.red : Color.secondary, lineWidth: 1))
                .foregroundColor(invalidInputName ? .red : .primary)
                .textContentType(.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            
            Picker(selection: self.$dhbwLocation, label: Text("Location")){
                Text("Karlsruhe")
                Text("Mannheim")
                Text("Stuttgart")
                Text("Mosbach")
            }.frame(maxWidth: 500, alignment: .center)
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("course".localized(tableName: "General"), text: self.$course)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(invalidInputCourse ? Color.red : Color.secondary, lineWidth: 1))
                .onChange(of: course, perform: { value in
                    self.setCourseInfo()
                    self.course = self.course.uppercased()
                })
                .foregroundColor(invalidInputCourse ? .red : .primary)
                .textContentType(.name)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 200, idealWidth: nil, maxWidth: 500, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .center)
                .padding(.horizontal)
            
            TextField("director".localized(tableName: "General") + " (" +  "filledAuto".localized(tableName: "General") + ")", text: self.$director)
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
    func setCourseInfo() {
        // TODO: Replace this with some database query or stuff like this to load actual data
        switch course {
            case "TINF19B4":
                director = "Jörn Eisenbiegler"
            default:
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
        let user = User(context: PersistenceController.shared.context)
        user.name = name
        user.course = course
        user.director = director
        
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
