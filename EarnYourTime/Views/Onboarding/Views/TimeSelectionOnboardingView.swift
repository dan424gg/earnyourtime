//
//  TimeSelectionOnboardingView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 4/4/25.
//

import SwiftUI

struct TimeSelectionOnboardingView: View {
    @Environment(OnboardingObservable.self) private var vm
    @AppStorage(StorageKey.checkpointTime.rawValue) private var checkpointTime = 0
    @AppStorage(StorageKey.badAppTime.rawValue) private var badAppTime = 0
    @State private var selectedDestination: SettingsDestination?

    var body: some View {
        VStack(spacing: 25) {
            VStack(spacing: 15) {
                Group {
                    Text("Set a ") + Text("Checkpoint").foregroundStyle(.blue) + Text(" goal to achieve...")
                }
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                
                Button {
                    selectedDestination = .checkpointTime
                } label: {
                    HStack {
                        Text("Checkpoint")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Spacer()
                        PermissionsArrowCheck(conditional: checkpointTime != 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .activityBackground(color: .blue)
                .frame(width: getWidthOfScreen() * 0.75)
            }
            
            VStack(spacing: 15) {
                Group {
                    Text("to be rewarded with ") + Text("Bad App Time").foregroundStyle(.red)
                }
                    .font(.title3)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

                Button {
                    selectedDestination = .badAppTimeLimit
                } label: {
                    HStack {
                        Text("Bad App Time")
                            .font(.title3)
                            .fontWeight(.medium)

                        Spacer()
                        PermissionsArrowCheck(conditional: badAppTime != 0)
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
                case .checkpointTime:
                    CheckpointTimeEditorView(updateMonitoring: false)
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                case .badAppTimeLimit:
                    BadAppTimeLimitEditorView(updateMonitoring: false)
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                default:
                    EmptyView()
            }
        }
        .onChange(of: [checkpointTime, badAppTime]) {
            if (checkpointTime != 0) && (badAppTime != 0) {
                vm.disableButton = false
            }
        }
        .onAppear {
            vm.disableButton = true
        }
    }
}

#Preview {
    TimeSelectionOnboardingView()
        .environment(OnboardingObservable())
        .environment(DeviceActivityModel())
}
