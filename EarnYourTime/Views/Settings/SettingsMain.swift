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
    
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = true
    @AppStorage(StorageKey.fullName.rawValue) var name: String = ""
    @AppStorage(StorageKey.colorScheme.rawValue) private var colorScheme: String = "system"
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
//                    SettingsButton(text: "Name", systemImage: "person") {
//                        selectedDestination = .name
//                    }
                    SettingsName(name: $name, text: "Name", systemImage: "person")
                    SettingsButton(text: "Notifications", systemImage: "bell") {
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
                    SettingsToggle(state: $vacationMode, text: "Vacation Mode", systemImage: "beach.umbrella")
                        .onChange(of: vacationMode) { (old, new) in
                            if !old && new && selectedDestination == .none {
                                selectedDestination = .vacationMode
                            }
                        }
                    SettingsButton(text: "Good Apps", systemImage: "hand.thumbsup") {
                        selectedDestination = .goodApps
                    }
                    SettingsButton(text: "Bad Apps", systemImage: "hand.thumbsdown") {
                        selectedDestination = .badApps
                    }
                    SettingsButton(text: "Checkpoint Time", systemImage: "flag.checkered") {
                        selectedDestination = .checkpointTime
                    }
                    SettingsButton(text: "Bad App Time Limit", systemImage: "timer") {
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
                    SettingsAppearancePicker(colorScheme: $colorScheme, text: "Theme", systemImage: "paintbrush")
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
                    SettingsButton(text: "Contact Us", systemImage: "envelope") {
                        selectedDestination = .contactUs
                    }
                    SettingsButton(text: "Rate Our App", systemImage: "star") {
                        selectedDestination = .rateApp
                    }
                    SettingsButton(text: "Privacy Policy", systemImage: "lock.shield") {
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
                    SettingsButton(text: "Delete Data", systemImage: "trash") {
                        selectedDestination = .deleteData
                    }
                    .foregroundStyle(Color.red)
                }
            }
            .navigationTitle("Settings")
            .scrollContentBackground(.hidden)// Add this
            .background(AppBackground())
        }
        .sheet(item: $selectedDestination, onDismiss: {
            selectedDestination = .none
        }) { destination in
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
