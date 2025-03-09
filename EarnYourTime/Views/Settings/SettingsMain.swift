//
//  SettingsMain.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

struct SettingsMain: View {
    enum SettingsDestination: Identifiable {
        case name
        case notifications
        case goodApps
        case badApps
        case checkpointTime
        case badAppTimeLimit
        case appearance
        case contactUs
        case rateApp
        case privacyPolicy
        case deleteData

        var id: Self { self }
    }
    
    @State private var selectedDestination: SettingsDestination? = .badApps

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal")) {
                    SettingsListItem(text: "Name", systemImage: "person") {
                        selectedDestination = .name
                    }
                    SettingsListItem(text: "Notifications", systemImage: "bell") {
                        selectedDestination = .notifications
                    }
                    SettingsListItem(text: "Good Apps", systemImage: "hand.thumbsup") {
                        selectedDestination = .goodApps
                    }
                    SettingsListItem(text: "Bad Apps", systemImage: "hand.thumbsdown") {
                        selectedDestination = .badApps
                    }
                    SettingsListItem(text: "Checkpoint Time", systemImage: "flag.checkered") {
                        selectedDestination = .checkpointTime
                    }
                    SettingsListItem(text: "Bad App Time Limit", systemImage: "timer") {
                        selectedDestination = .badAppTimeLimit
                    }
                }
                
                Section(header: Text("Appearance")) {
                    SettingsListItem(text: "Placeholder for Picker", systemImage: "paintbrush") {
                        selectedDestination = .appearance
                    }
                }
                
                Section(header: Text("Other")) {
                    SettingsListItem(text: "Contact Us", systemImage: "envelope") {
                        selectedDestination = .contactUs
                    }
                    SettingsListItem(text: "Rate Our App", systemImage: "star") {
                        selectedDestination = .rateApp
                    }
                    SettingsListItem(text: "Privacy Policy", systemImage: "lock.shield") {
                        selectedDestination = .privacyPolicy
                    }
                }
                
                Section {
                    SettingsListItem(text: "Delete Data", systemImage: "trash") {
                        selectedDestination = .deleteData
                    }
                    .foregroundStyle(Color.red)
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)// Add this
            .background(AppBackground())
        }
        .sheet(item: $selectedDestination) { destination in
            switch destination {
                case .name:
                    NameEditorView()
                     .presentationDetents([.medium])
                     .presentationDragIndicator(.visible)
                case .notifications:
                    NotificationsSettingsView()
                case .goodApps:
                    GoodAppsView()
                case .badApps:
                    BadAppsSelectorView()
                case .checkpointTime:
                    CheckpointTimeEditorView()
                     .presentationDetents([.fraction(0.6)])
                     .presentationDragIndicator(.visible)
                case .badAppTimeLimit:
                    BadAppTimeLimitEditorView()
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                case .appearance:
                    AppearanceSettingsView()
                case .contactUs:
                    ContactUsView()
                case .rateApp:
                    RateAppView()
                case .privacyPolicy:
                    PrivacyPolicyView()
                case .deleteData:
                    DeleteDataView()
            }
        }
    }
}


#Preview {
    ZStack {
        AppBackground()
        SettingsMain()
            .environment(DeviceActivityModel())
    }
}
