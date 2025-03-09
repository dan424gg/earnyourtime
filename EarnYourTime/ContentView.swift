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
    let notificationsManager = NotificationsManager()
    let center = AuthorizationCenter.shared

    var body: some View {
        ZStack {
            AppBackground()
            Home()
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
                                .providesAppNotificationSettings])
                        } catch {
                            print(error)
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(DeviceActivityModel())
}
