//
//  LecturePlanList.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 30.01.21.
//

import SwiftUI
import CoreData

struct LecturePlanList: View {
    @State private var events: [RaPlaEvent] = []
    @State private var daysWithEvents: [Date:[RaPlaEvent]] = [:]
    @State private var sortingAscending = true
    
    var body: some View {
        NavigationView() {
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in
//                    Button("Jump to today") {
//                        withAnimation(){
//                            scrollView.scrollTo(8, anchor: .center)
//                        }
//                    }
//                    .padding()
                    
                    ForEach(daysWithEvents.sorted(by: {$0.key < $1.key}), id: \.key) { key, value in
                        let dayBlock = DayWithEventsBlock(date: key, eventsList: value, parent: self)
                        dayBlock
                    }
                    
                    
                }
            }
            .navigationBarTitle(Text("Lectures"))
            //                .navigationBarItems(trailing: {
            //                    Button(action: {
            //                        // This is obviously bullshit, but it could be used to sort afer summary or smth like that
            //
            //                        self.sortingAscending = !self.sortingAscending
            //                        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: sortingAscending)
            //                        let sortDescriptors = [sectionSortDescriptor]
            //                        self.events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors)
            //                    }){
            //                        Text("Switch order")
            //                    }
            //                })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear{
            self.getRaPlaEvents()
            self.findNextDay()
        }
    }
}

struct LecturePlanList_Previews: PreviewProvider {
    static var previews: some View {
        LecturePlanList()
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

extension LecturePlanList {
    public func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    public func getEventForegroundColor(for event: RaPlaEvent) -> Color {
        var textColor: Color = .primary
        if(event.category! == "Prüfung") {
            textColor = Color.red
        } else {
            textColor = Color.primary
        }
        
        return textColor
    }
    
    public func findNextDay() {
        // As this list is already sorted ascending, we can just return the first event with a start date that is in the future
        let sortedEvents = self.events.sorted(by: { $0.startDate! < $1.startDate! })
        for event in sortedEvents {
            if(event.startDate! > Date()) {
                //self.focusedEvent = event
                return
            }
        }
    }
    
    public func getRaPlaEvents() {
        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let dateFrom = calendar.startOfDay(for: Date())
        let fromPredicate = NSPredicate(format: "startDate >= %@", dateFrom as NSDate)
        
        self.events = []
        self.daysWithEvents = [:]
        
        self.events = RaPlaEvent.getSpecified(sortDescriptors: sortDescriptors, searchPredicate: fromPredicate)
        
        // Also write events to daysWithEvents map
        for event in self.events {
            let components = event.startDate!.get(.day, .month, .year)
            let day = String(components.day!); let month = String(components.month!); let year = String(components.year!)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dayOnly = dateFormatter.date(from: String(year + "-" + month + "-" + day))!
            
            var eventsList = daysWithEvents[dayOnly]
            if(eventsList == nil) {
                eventsList = []
            }
            eventsList!.append(event)
            self.daysWithEvents[dayOnly] = eventsList
        }
    }
}

struct DayWithEventsBlock: View {
    @State var date: Date
    @State var eventsList: [RaPlaEvent]
    @State var parent: LecturePlanList
    
    var body: some View {
        VStack {
            Text(String(date.get(.day)) + "." + String(date.get(.month)) + "." + String(date.get(.year)))
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if(!eventsList.isEmpty){
                    ForEach(eventsList, id: \.self) { event in
                        NavigationLink(destination: LecturePlanItem(event: event)) {
                            HStack {
                                Text(parent.formatDate(date: event.startDate!))
                                    .foregroundColor(parent.getEventForegroundColor(for: event))
                                Text(event.summary!)
                                    .foregroundColor(parent.getEventForegroundColor(for: event))

                                Spacer()

                                if(event.isHidden) {
                                    Image(systemName: "eye.slash")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "eye")
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                            )
                        }
                        // When an event gets updated from child view, reload it here as this will not trigger the onAppear() function
                        .onReceive(event.objectWillChange, perform: { _ in
                            print("receiving event")
                            parent.getRaPlaEvents()
                        })
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
    }
}
