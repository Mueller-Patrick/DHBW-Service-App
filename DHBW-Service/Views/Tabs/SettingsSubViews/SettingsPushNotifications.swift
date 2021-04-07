//
//  SettingsPushNotifications.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 16.02.21.
//

import SwiftUI

struct SettingsPushNotifications: View {
    @State private var notificationsEnabled = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $notificationsEnabled) {
                Text("Receive push notifications")
            }
            .frame(maxWidth: 500, alignment: .center)
            
            Button(action: {
                scheduleTestNotification()
            }){
                Text("Test Notification")
            }
        }
        .onChange(of: notificationsEnabled) { newVal in
            if(newVal) {
                enablePushService()
            }
        }
    }
}

extension SettingsPushNotifications {
    private func enablePushService() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            //This callback does not trigger on main loop be careful
            if allowed {
                print("Allowed")
            
                // Get token
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Error")
            }
        }
    }
    
    private func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Exam"
        content.subtitle = "Your exam in theoretical computer science 3 is one week from now."
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}

struct SettingsPushNotifications_Previews: PreviewProvider {
    static var previews: some View {
        SettingsPushNotifications()
    }
}
