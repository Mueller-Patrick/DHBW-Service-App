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
        }
        .onAppear{
            self.isHidden = event.value(forKey: "isHidden") as! Bool
        }
    }
}

struct LecturePlanItem_Previews: PreviewProvider {
    static var previews: some View {
        LecturePlanItem(event: getPreviewEvent())
            .preferredColorScheme(.dark)
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
