//
//  SettingsMain.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 28.12.20.
//

import SwiftUI

struct SettingsMain: View {
    @EnvironmentObject var settings: LocalSettings
    @State private var showLogoutConfirmationAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("other".localized(tableName: "General", plural: false))) {
                    NavigationLink(
                        destination: SettingsAcknowledgements(),
                        label: {
                            Text("Acknowledgements")
                        })
                    Button(action: {
                        self.showLogoutConfirmationAlert = true
                    }, label: {
                        Text("logoutClearData".localized(tableName: "General", plural: false))
                    })
                }
            }
            .navigationTitle("settings".localized(tableName: "General", plural: false))
            .listStyle(GroupedListStyle())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showLogoutConfirmationAlert, content: {
            Alert(
                title: Text("logout".localized(tableName: "General", plural: false)),
                message: Text("confirmLogoutMessage".localized(tableName: "General", plural: false)),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Ok")){
                    self.logoutAndClearData()
                })
        })
    }
}

extension SettingsMain {
    private func logoutAndClearData() {
        // TODO: Adjust before release!
        UtilityFunctions.deleteAllData()
        self.settings.isFirstOpening = true
    }
}

struct SettingsMain_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMain()
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
