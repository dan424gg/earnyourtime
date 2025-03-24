//
//  SettingsMain.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import StoreKit

struct SettingsMain: View {    
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
    @AppStorage(StorageKey.fullName.rawValue) var name: String = ""
    @AppStorage(StorageKey.colorScheme.rawValue) private var colorScheme: String = "system"
    
    @Environment(\.requestReview) var requestReview
    @Environment(\.openURL) var openURL

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
                                selectedCategory = .appExperience
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
                                selectedCategory = .appearance
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
                                selectedCategory = .other
                            }
                    }
                ) {
                    SettingsButton(text: "Contact Us", systemImage: "envelope") {
                        openEmail(email: "some_email@gmail.com", subject: "Feedback")
                    }
                    SettingsButton(text: "Rate Our App", systemImage: "star") {
                        requestReview()
                    }
                    SettingsButton(text: "Request a Feature", systemImage: "wrench") {
                        openURL(URL(string: "https://earnyourtime.featurebase.app")!)
                    }
                    SettingsButton(text: "Privacy Policy", systemImage: "lock.shield") {
//                        selectedDestination = .privacyPolicy
                    }
                    SettingsButton(text: "Delete Data", systemImage: "trash") {
//                        selectedDestination = .deleteData
                    }
                    .foregroundStyle(Color.red)
                }
            }
            .padding([.leading, .trailing], 5)
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
                     .presentationBackground(.thinMaterial)
                case .notifications:
                    NotificationsSettingsView()
                case .vacationMode:
                    VacationModeView()
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                case .goodApps:
                    GoodAppsSelectorView()
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                case .badApps:
                    BadAppsSelectorView()
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                case .checkpointTime:
                    CheckpointTimeEditorView()
                     .presentationDetents([.fraction(0.6)])
                     .presentationDragIndicator(.visible)
                     .presentationBackground(.thinMaterial)
                case .badAppTimeLimit:
                    BadAppTimeLimitEditorView()
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                case .appearance:
                    AppearanceSettingsView()
            }
        }
        .sheet(item: $selectedCategory) { category in
            switch category {
                case .personal:
                    PersonalInfo()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                        .scrollDisabled(true)
                    
                case .appExperience:
                    AppExperienceInfo()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)

                case .appearance:
                    AppearanceInfo()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                        .scrollDisabled(true)

                case .other:
                    OtherInfo()
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)

            }
        }
    }
}


#Preview {
    ZStack {
        AppBackground()
        SettingsMain()
    }
}
