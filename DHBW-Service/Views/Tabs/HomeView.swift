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
                HStack {
                    Text("Next Theory Phase: ")
                    Text(getNextTheoryPhaseStartDate())
                }
                
                // Upcoming events section
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("today".localized(tableName: "HomeView"))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            if(!todaysEvents.isEmpty){
                                ForEach(todaysEvents, id: \.self) { exam in
                                    Text(exam.value(forKey: "summary") as! String)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                Text("noLectures".localized(tableName: "HomeView"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                    )
                    
                    VStack {
                        Text("tomorrow".localized(tableName: "HomeView"))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            if(!tomorrowsEvents.isEmpty){
                                ForEach(tomorrowsEvents, id: \.self) { exam in
                                    Text(exam.value(forKey: "summary") as! String)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                Text("noLectures".localized(tableName: "HomeView"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                    )
                    
                    Spacer()
                }
                
                // Exams section
                HStack {
                    Spacer()
                    
                    VStack {
                        Text("upcomingExams".localized(tableName: "HomeView"))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        VStack {
                            if(!upcomingExams.isEmpty){
                                ForEach(upcomingExams, id: \.self) { exam in
                                    Text(exam.value(forKey: "summary") as! String)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            } else {
                                Text("noExams".localized(tableName: "HomeView"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 4)
                    )
                    
                    Spacer()
                }
            }
            .navigationBarTitle(Text("Home"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            self.readFromCoreData()
            self.todaysEvents = getTodaysEvents()
            self.tomorrowsEvents = getTomorrowsEvents()
            self.upcomingExams = getUpcomingExams()
        }
    }
}

extension HomeView{
    // Read required data from CoreData and save it to the appropriate variables
    func readFromCoreData() {
        let fetchedData = UtilityFunctions.getCoreDataObject(entity: "User")
        
        if(!fetchedData.isEmpty) {
            let user = fetchedData[0]
            self.name = user.value(forKey: "name") as! String
            self.course = user.value(forKey: "course") as! String
            self.director = user.value(forKey: "director") as! String
        }
    }
    
    // Get 0...2 of todays lectures from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getTodaysEvents() -> [NSManagedObject] {
        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung')")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        var predicates = [searchPredicate, hiddenPredicate]
        predicates.append(contentsOf: getDayPredicates(today: true))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", searchPredicate: compoundPredicate)
        if(!events.isEmpty) {
            return Array(events[...min(1, events.count-1)])
        } else {
            return []
        }
    }
    
    // Get 0...2 of tomorrows lectures from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getTomorrowsEvents() -> [NSManagedObject] {
        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung')")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        var predicates = [searchPredicate, hiddenPredicate]
        predicates.append(contentsOf: getDayPredicates(tomorrow: true))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", searchPredicate: compoundPredicate)
        if(!events.isEmpty) {
            return Array(events[...min(1, events.count-1)])
        } else {
            return []
        }
    }
    
    // Get 0...2 of upcoming exams from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getUpcomingExams() -> [NSManagedObject] {
        let searchPredicate = NSPredicate(format: "category == %@", "Prüfung")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, hiddenPredicate])
        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        let events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors, searchPredicate: compoundPredicate)
        if(!events.isEmpty) {
            return Array(events[...min(1, events.count-1)])
        } else {
            return []
        }
    }
    
    // Get the required NSPredicates to fetch only RaPla events with a start date that is today
    func getDayPredicates(today: Bool = false, tomorrow: Bool = false) -> [NSPredicate] {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        var dateFrom = Date()
        var dateTo = Date()
        if(today) {
            //Get today's beginning & end
            dateFrom = calendar.startOfDay(for: Date())
            dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        } else if (tomorrow) {
            dateFrom = calendar.startOfDay(for: Date())
            dateFrom = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
            dateTo = calendar.date(byAdding: .day, value: 2, to: dateFrom)!
        }
        
        let fromPredicate = NSPredicate(format: "startDate >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "startDate < %@", dateTo as NSDate)
        
        return [fromPredicate, toPredicate]
    }
    
    // Get the formatted date when the next theory phase starts
    func getNextTheoryPhaseStartDate() -> String {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let categoryPredicate = NSPredicate(format: "category == %@", "Sonstiger Termin")
        let datePredicate = NSPredicate(format: "startDate >= %@", calendar.startOfDay(for: Date()) as NSDate)
        let titlePredicate = NSPredicate(format: "summary CONTAINS[cd] %@", "beginn")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, datePredicate, titlePredicate])
        
        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        
        let events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors, searchPredicate: compoundPredicate)
        
        if(!events.isEmpty) {
            let date = events[0].value(forKey: "startDate") as! Date
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        } else {
            return "N/A"
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
