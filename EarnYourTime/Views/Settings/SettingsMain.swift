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
        case vacationMode
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
    
    enum SettingsCategory: Identifiable {
        case personal
        case appExperience
        case appearance
        case other
        
        var id: Self { self }
    }
    
    @State private var selectedDestination: SettingsDestination?
    @State private var selectedCategory: SettingsCategory?

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: HStack {
                        Text("Personal")
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                selectedCategory = .personal
                            }
                    }
                ) {
                    SettingsListItem(text: "Name", systemImage: "person") {
                        selectedDestination = .name
                    }
                    SettingsListItem(text: "Notifications", systemImage: "bell") {
                        selectedDestination = .notifications
                    }
                }
                
                Section(
                    header: HStack {
                        Text("App Experience")
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                selectedCategory = .personal
                            }
                    }
                ) {
                    SettingsListItem(text: "Vacation Mode", systemImage: "beach.umbrella") {
                        selectedDestination = .vacationMode
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
                
                Section(
                    header: HStack {
                        Text("Appearance")
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                selectedCategory = .personal
                            }
                    }
                ) {
                    SettingsListItem(text: "Placeholder for Picker", systemImage: "paintbrush") {
                        selectedDestination = .appearance
                    }
                }
                
                Section(
                    header: HStack {
                        Text("Other")
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                selectedCategory = .personal
                            }
                    }
                ) {
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
                
                Section(
                    header: HStack {
                        Text("Data")
                        Image(systemName: "info.circle")
                            .onTapGesture {
                                selectedCategory = .personal
                            }
                    }
                ) {
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
                case .vacationMode:
                    VacationModeView()
                case .goodApps:
                    GoodAppsSelectorView()
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
        .sheet(item: $selectedCategory) { category in
            Text("nothing yet for \(category)")
//            switch selectedCategory {
//                case .personal:
//                    <#code#>
//                case .appExperience:
//                    <#code#>
//                case .appearance:
//                    <#code#>
//                case .other:
//                    <#code#>
//                case nil:
//                    <#code#>
//            }
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
