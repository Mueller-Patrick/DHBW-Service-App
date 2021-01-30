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
    
    var body: some View {
        List {
            ForEach(events, id: \.self) { event in
                HStack {
                    Text(formatDate(date: event.value(forKeyPath: "startDate") as! Date))
                    Text(event.value(forKeyPath: "summary") as! String)
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
    }
}

extension LecturePlanList {
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
