//
//  LecturePlanItem.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 01.02.21.
//

import SwiftUI
import CoreData

struct LecturePlanItem: View {
    @State var event: NSManagedObject
    @State var isHidden = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(event.value(forKey: "summary") as! String)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(event.value(forKey: "descr") as! String)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("When")
                            Text("Where")
                            Text("Who")
                        }
                        VStack(alignment: .leading) {
                            Text(getDateAndTimeAsString(date: event.value(forKey: "startDate") as! Date)
                                    + " to "
                                    + getTimeAsString(date: event.value(forKey: "endDate") as! Date))
                                .bold()
                            Text(event.value(forKey: "location") as! String)
                                .bold()
                            Text(event.value(forKey: "location") as! String)
                                .bold()
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Divider()
                    HStack {
                        Button(action: {
                            event.setValue(!isHidden, forKey: "isHidden")
                            self.isHidden = !isHidden
                            PersistenceController.shared.save()
                        }){
                            if(self.isHidden){
                                Text("Show")
                            } else {
                                Text("Hide")
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(15)
                        Spacer()
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                )
                Spacer()
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .onAppear{
            self.isHidden = event.value(forKey: "isHidden") as! Bool
        }
    }
}

func getDateAndTimeAsString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    
    return formatter.string(from: date)
}

func getTimeAsString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    
    return formatter.string(from: date)
}

struct LecturePlanItem_Previews: PreviewProvider {
    static var previews: some View {
        LecturePlanItem(event: getPreviewEvent())
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
    
    static func getPreviewEvent() -> NSManagedObject {
        return UtilityFunctions.getCoreDataObject(entity: "RaPlaEvent", sortDescriptors: [])[0]
    }
}
