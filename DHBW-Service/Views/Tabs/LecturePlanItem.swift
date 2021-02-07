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
            VStack {
                Text(event.value(forKey: "summary") as! String)
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                VStack(alignment: .leading) {
                    Text("When")
                    Text("Where")
                }
                VStack(alignment: .leading) {
                    Text(getDateAsString(date: event.value(forKey: "startDate") as! Date) )
                        .bold()
                    Text(event.value(forKey: "location") as! String)
                        .bold()
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
        )
            Spacer()
            Text(event.value(forKey: "summary") as! String)
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
        .onAppear{
            self.isHidden = event.value(forKey: "isHidden") as! Bool
        }
    }
}

func getDateAsString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
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
