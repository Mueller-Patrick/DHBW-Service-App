//
//  LecturePlanList.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 30.01.21.
//

import SwiftUI
import CoreData

struct LecturePlanList: View {
    @State private var events: [NSManagedObject] = []
    @State private var sortingAscending = true
    
    var body: some View {
        VStack {
            Button(action: {
                // This is obviously bullshit, but it could be used to sort afer summary or smth like that
                
                self.sortingAscending = !self.sortingAscending
                let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: sortingAscending)
                let sortDescriptors = [sectionSortDescriptor]
                self.events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors)
            }){
                Text("Switch order")
            }
            List {
                ForEach(events, id: \.self) { event in
                    HStack {
                        Text(formatDate(date: event.value(forKeyPath: "startDate") as! Date))
                            .foregroundColor(getEventForegroundColor(for: event))
                        Text(event.value(forKeyPath: "summary") as! String)
                            .foregroundColor(getEventForegroundColor(for: event))
                    }
                }
            }
        }.onAppear{
            let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            self.events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors)
        }
    }
}

struct LecturePlanList_Previews: PreviewProvider {
    static var previews: some View {
        LecturePlanList()
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

extension LecturePlanList {
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func getEventForegroundColor(for event: NSManagedObject) -> Color {
        var textColor: Color = .primary
        if(event.value(forKeyPath: "category") as! String == "Prüfung") {
            textColor = Color.red
        } else {
            textColor = Color.primary
        }
        
        return textColor
    }
}
