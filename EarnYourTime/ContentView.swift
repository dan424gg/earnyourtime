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

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            AppBackground()
            if seenIntroSequence {
                Home()
            } else {
                OnboardingView()
            }
        }
        .animation(.default, value: seenIntroSequence)
    }
}

#Preview {
    ContentView()
        .environment(DeviceActivityModel())
        .environment(OnboardingObservable())
}
