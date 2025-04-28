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
    @AppStorage(StorageKey.recentUpdateTime.rawValue) private var recentUpdateTime: Double = 0

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
            Testing()
//            if seenIntroSequence {
//                Home()
//            } else {
//                OnboardingView()
//            }
        }
        .animation(.default, value: seenIntroSequence)
        .onAppear {
//            if Date().timeIntervalSince1970 > getEod(recentUpdateTime) {
//                recentUpdateTime = -1
//            }

            recentUpdateTime = Date().timeIntervalSince1970
            print(Date(timeIntervalSince1970: recentUpdateTime))
        }
    }
}

#Preview {
    ContentView()
        .environment(DeviceActivityModel())
        .environment(OnboardingObservable())
}
