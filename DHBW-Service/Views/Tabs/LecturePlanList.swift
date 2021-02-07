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
        NavigationView() {
            List {
                ForEach(events, id: \.self) { event in
                    NavigationLink(destination: LecturePlanItem(event: event)){
                        HStack {
                            Text(formatDate(date: event.value(forKeyPath: "startDate") as! Date))
                                .foregroundColor(getEventForegroundColor(for: event))
                            Text(event.value(forKeyPath: "summary") as! String)
                                .foregroundColor(getEventForegroundColor(for: event))
                            
                            Spacer()
                            
                            if(event.value(forKey: "isHidden") as! Bool) {
                                Image(systemName: "eye.slash")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "eye")
                            }
                        }
                    }
                    // When an event gets updated from child view, reload it here as this will not trigger the onAppear() function
                    .onReceive(event.objectWillChange, perform: { _ in
                        let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
                        let sortDescriptors = [sectionSortDescriptor]
                        self.events = []
                        self.events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors)
                    })
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
            let sectionSortDescriptor = NSSortDescriptor(key: "startDate", ascending: true)
            let sortDescriptors = [sectionSortDescriptor]
            self.events = []
            self.events = UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: sortDescriptors)
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
