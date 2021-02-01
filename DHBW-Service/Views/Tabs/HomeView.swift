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
    @State private var todaysEvents: [NSManagedObject] = []
    @State private var tomorrowsEvents: [NSManagedObject] = []
    @State private var upcomingExams: [NSManagedObject] = []
    
    var body: some View {
        NavigationView {
            VStack {
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
                
                // Upcoming events section
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("Today's events")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity)
                        VStack {
                            Text("Evt 1")
                            Text("Evt 2")
                        }
                    }
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 4)
                    )
                    
                    VStack {
                        Text("Tomorrow's events")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity)
                        VStack {
                            Text("Evt 1")
                            Text("Evt 2")
                        }
                    }
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 4)
                    )
                    
                    Spacer()
                }
                
                // Exams section
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("Upcoming exams")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity)
                        VStack {
                            ForEach(upcomingExams, id: \.self) { exam in
                                Text(exam.value(forKey: "summary") as! String)
                            }
                        }
                    }
                    .padding()
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 4)
                    )
                    
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Home"))
        }.onAppear{
            self.readFromCoreData()
            self.upcomingExams = getUpcomingExams()
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
    
    func getTodaysEvents() -> [NSManagedObject] {
//        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung') AND (startDate = %@)", Date())
//        return Array(UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", searchPredicate: searchPredicate)[0...1])
        return []
    }
    
    func getTomorrowsEvents() -> [NSManagedObject] {
//        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung') AND (startDate = %@)", Date().)
//        return Array(UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", searchPredicate: searchPredicate)[0...1])
        return []
    }
    
    func getUpcomingExams() -> [NSManagedObject] {
        let searchPredicate = NSPredicate(format: "category == %@", "Prüfung")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, hiddenPredicate])
        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        let events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors, searchPredicate: compoundPredicate)
        if(events.count > 0) {
            return Array(events[0...min(1, events.count)])
        } else {
            return []
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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
