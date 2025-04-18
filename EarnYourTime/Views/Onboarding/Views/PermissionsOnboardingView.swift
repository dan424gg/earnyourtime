//
//  PermissionsOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI
import FamilyControls

struct PermissionsOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    @State var notificationsAllowed: Bool = false
    @State var deviceActivityAllowed: Bool = false
    let notificationsManager = NotificationsManager()
    let center = AuthorizationCenter.shared

    var body: some View {
        VStack(spacing: 50) {
            Text("To get started, we first need some permissions from you.")
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Button {
                    // needed for foreground notifications
                    notificationsManager.setupNotificationDelegate()
                    
                    // needed for notifications
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
                        
                        notificationsAllowed = true
                    }
                } label: {
                    HStack {
                        Text("Notifications")
                            .font(.title3)
                            .fontWeight(.medium)

                        Spacer()
                        PermissionsArrowCheck(conditional: notificationsAllowed)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .activityBackground(color: .orange)
                .frame(width: getWidthOfScreen() * 0.75)
                
                Button {
                    Task {
                        do {
                            try await center.requestAuthorization(for: .individual)
                        } catch {
                            print("couldn't get authorization for Device Activity\n\(error)")
                        }
                        
                        deviceActivityAllowed = true
                    }
                } label: {
                    HStack {
                        Text("Device Activity")
                            .font(.title3)
                            .fontWeight(.medium)

                        Spacer()
                        PermissionsArrowCheck(conditional: deviceActivityAllowed)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .activityBackground(color: .orange)
                .frame(width: getWidthOfScreen() * 0.75)
            }
        }
        .onChange(of: [notificationsAllowed, deviceActivityAllowed], initial: true) {
            if notificationsAllowed && deviceActivityAllowed {
                vm.disableButton = false
            }
        }
        .onAppear {
            vm.disableButton = true
        }
    }
}

#Preview {
    PermissionsOnboardingView()
        .environment(OnboardingObservable())
}
