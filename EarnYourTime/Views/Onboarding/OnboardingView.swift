//
//  OnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(StorageKey.seenIntroSequence.rawValue) private var seenIntroSequence = false
    @AppStorage(StorageKey.recentUpdateTime.rawValue) private var recentUpdateTime: TimeInterval = -1
    @Environment(OnboardingObservable.self) private var vm
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    
    var body: some View {
        VStack {
            ZStack {
                switch vm.phase {
                    case 0:
                        IntroOnboardingView()
                    case 1:
                        TextOnboardingView()
                    case 2:
                        NameOnboardingView()
                    case 3:
                        PermissionsOnboardingView()
                    case 4:
                        AppSelectionOnboardingView()
                    case 5:
                        TimeSelectionOnboardingView()
                    case 6:
                        FinalOnboardingView()
                    default:
                        EmptyView()
                }
            }
            .ignoresSafeArea()
            .transition(.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading))
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            if vm.phase != 2 && vm.phase < 6 {
                ActionButton(disabled: vm.disableButton, text: "Continue") {
                    withAnimation {
                        vm.phase += 1
                        
                        if vm.phase == 6 {
                            do {
                                try deviceActivityModel.startMonitoring()
                            } catch {}
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                vm.phase = 6
                                recentUpdateTime = Date().timeIntervalSince1970
                                seenIntroSequence = true
                            }
                        }
                    }
                }
                .padding(.bottom)
            }
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    ZStack {
        AppBackground()
        OnboardingView()
            .environment(OnboardingObservable())
            .environment(DeviceActivityModel())
    }
}

