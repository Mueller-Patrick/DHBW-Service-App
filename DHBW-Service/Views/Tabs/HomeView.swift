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
    @State private var todaysEvents: [RaPlaEvent] = []
    @State private var tomorrowsEvents: [RaPlaEvent] = []
    @State private var upcomingExams: [RaPlaEvent] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("hey".localized(tableName: "HomeView", plural: false))
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(self.name)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.primaryColor)
                    )
                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack {
                        Text("information".localized(tableName: "HomeView", plural: false))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            VStack(alignment: .leading) {
                                Text("course".localized(tableName: "General", plural: false) + ": ")
                                Text("director".localized(tableName: "General", plural: false) + ": ")
                            }
                            VStack(alignment: .leading) {
                                Text(self.course)
                                    .bold()
                                Text(self.director)
                                    .bold()
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.primaryColor)
                    )
                    Spacer()
                }
                Spacer()
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
                    
                    // Todays lectures block
                    UpcomingLecturesBlock(eventsList: todaysEvents, titleKey: "today")
                    
                    // Tomorrows lectures block
                    UpcomingLecturesBlock(eventsList: tomorrowsEvents, titleKey: "tomorrow")
                    
                    Spacer()
                }
                
                // Exams section
                HStack {
                    Spacer()
                    
                    UpcomingExamsBlock(examsList: upcomingExams, titleKey: "upcomingExams")
                    
                    Spacer()
                }
                Spacer()
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
        let fetchedData = User.getAll()
        
        if(!fetchedData.isEmpty) {
            let user = fetchedData[0]
            self.name = user.name!
            self.course = user.course!
            self.director = user.director!
        }
    }
    
    // Get 0...2 of todays lectures from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getTodaysEvents() -> [RaPlaEvent] {
        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung')")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        var predicates = [searchPredicate, hiddenPredicate]
        predicates.append(contentsOf: getDayPredicates(today: true))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let events = RaPlaEvent.getSpecified(searchPredicate: compoundPredicate)
        if(!events.isEmpty) {
            return Array(events[...min(1, events.count-1)])
        } else {
            return []
        }
    }
    
    // Get 0...2 of tomorrows lectures from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getTomorrowsEvents() -> [RaPlaEvent] {
        let searchPredicate = NSPredicate(format: "(category == 'Lehrveranstaltung')")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        var predicates = [searchPredicate, hiddenPredicate]
        predicates.append(contentsOf: getDayPredicates(tomorrow: true))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let events = RaPlaEvent.getSpecified(searchPredicate: compoundPredicate)
        if(!events.isEmpty) {
            return Array(events[...min(1, events.count-1)])
        } else {
            return []
        }
    }
    
    // Get 0...2 of upcoming exams from RaPla
    // Returns a list of RaPlaEvent NSManagedObjects
    func getUpcomingExams() -> [RaPlaEvent] {
        let searchPredicate = NSPredicate(format: "category == %@", "Prüfung")
        let hiddenPredicate = NSPredicate(format: "isHidden == NO")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, hiddenPredicate])
        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        let events = RaPlaEvent.getSpecified(sortDescriptors: sortDescriptors, searchPredicate: compoundPredicate)
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

struct UpcomingLecturesBlock: View {
    let eventsList: [RaPlaEvent]
    let titleKey: String
    
    var body: some View {
        VStack {
            Text(titleKey.localized(tableName: "HomeView"))
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if(!eventsList.isEmpty){
                    ForEach(eventsList, id: \.self) { exam in
                        Text(exam.summary!)
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
                .fill(Color.primaryColor)
        )
    }
}

struct UpcomingExamsBlock: View {
    let examsList: [RaPlaEvent]
    let titleKey: String
    
    var body: some View {
        VStack {
            Text(titleKey.localized(tableName: "HomeView"))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if(!examsList.isEmpty){
                    ForEach(examsList, id: \.self) { exam in
                        Text(exam.summary!)
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
                .fill(Color.primaryColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("AccentColor"), lineWidth: 4)
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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
