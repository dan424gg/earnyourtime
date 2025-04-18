//
//  AppSelectionOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct AppSelectionOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    @AppStorage(StorageKey.goodFamilySelections.rawValue) private var goodFamilySelections = Data()
    @AppStorage(StorageKey.badFamilySelections.rawValue) private var badFamilySelections = Data()
    @State private var selectedDestination: SettingsDestination?
    
    var body: some View {
        VStack(spacing: 50) {
            Group {
                Text("Now, pick your\n") + Text("good").foregroundStyle(.green) + Text(" and ") + Text("bad").foregroundStyle(.red) + Text(" apps")
            }
                .font(.title)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                Button {
                    selectedDestination = .goodApps
                } label: {
                    HStack {
                        Text("Good Apps")
                            .font(.title3)
                            .fontWeight(.medium)

                        Spacer()
                        PermissionsArrowCheck(conditional: goodFamilySelections != Data())
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .activityBackground(color: .green)
                .frame(width: getWidthOfScreen() * 0.75)
                
                Button {
                    selectedDestination = .badApps
                } label: {
                    HStack {
                        Text("Bad Apps")
                            .font(.title3)
                            .fontWeight(.medium)

                        Spacer()
                        PermissionsArrowCheck(conditional: badFamilySelections != Data())
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .activityBackground(color: .red)
                .frame(width: getWidthOfScreen() * 0.75)
            }
        }
        .sheet(item: $selectedDestination, onDismiss: {
            selectedDestination = .none
        }) { destination in
            switch destination {
                case .goodApps:
                    GoodAppsSelectorView(updateMonitoring: false)
                        .presentationBackground(.thinMaterial)
                case .badApps:
                    BadAppsSelectorView(updateMonitoring: false)
                        .presentationBackground(.thinMaterial)
                default:
                    EmptyView()
            }
        }
        .onChange(of: [goodFamilySelections, badFamilySelections]) {
            if goodFamilySelections != Data() && badFamilySelections != Data() {
                vm.disableButton = false
            }
        }
        .onAppear {
            vm.disableButton = true
        }
    }
}

#Preview {
    AppSelectionOnboardingView()
        .environment(OnboardingObservable())
        .environment(DeviceActivityModel())
}
