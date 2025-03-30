//
//  ContentView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import SwiftData
import UserNotifications
import FamilyControls

struct ContentView: View {
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    
    @AppStorage(StorageKey.seenIntroSequence.rawValue) var seenIntroSequence: Bool = false
    let notificationsManager = NotificationsManager()
    let center = AuthorizationCenter.shared

    @AppStorage(StorageKey.badAppTime.rawValue) var badAppTime: Int = 0
    @AppStorage(StorageKey.checkpointTime.rawValue) var checkpointTime: Int = 0
    @AppStorage(StorageKey.goodFamilySelections.rawValue) private var goodFamilySelectionsData: Data = Data()
    @AppStorage(StorageKey.badFamilySelections.rawValue) private var badFamilySelectionsData: Data = Data()

    @State private var selectedDestination: SettingsDestination?
    @Environment(\.dismiss) var dismiss

    func isAllFilledOut() -> Bool {
        return goodFamilySelectionsData != Data()
                && badFamilySelectionsData != Data()
                && checkpointTime != 0
                && badAppTime != 0
    }
    
    var body: some View {
        ZStack {
            AppBackground()
            if seenIntroSequence {
//                testing()
                Home()
            } else {
                // we want some sort of mechanism to nil out the defaults if the user doesn't go all the way through with the introduction
                NavigationView {
                    List {
                        Section() {
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
                    }
                    .padding([.leading, .trailing], 5)
                    .navigationTitle("Temporary Intro Set Up")
                    .scrollContentBackground(.hidden)// Add this
                    .background(AppBackground())
                }
                .safeAreaInset(edge: .bottom) {
                    ActionButton(disabled: !isAllFilledOut()) {
                        seenIntroSequence = true
                        do {
                            try deviceActivityModel.startMonitoring()
                        } catch {
                            print("error in startMonitoring")
                        }
                        dismiss()
                    }
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
                            EmptyView()
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
            }
        }
        .onAppear {
            /// needed for device activity
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                } catch {
                    print("couldn't get authorization for Device Activity\n\(error)")
                }
            }
            
            /// needed for foreground notifications
            notificationsManager.setupNotificationDelegate()
            
            /// needed for notifications
            Task {
                do {
                    // todo: finalize options
                    try await UNUserNotificationCenter.current().requestAuthorization(options: [
                        .alert,
                        .sound,
                        .badge,
                        .carPlay,
                        .criticalAlert,
                        .providesAppNotificationSettings])
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(DeviceActivityModel())
}
