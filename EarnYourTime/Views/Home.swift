//
//  Home.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct Home: View {
    @Environment(DeviceActivityModel.self) private var model
    @AppStorage(StorageKey.fullName.rawValue) var userName: String = ""
    @AppStorage(StorageKey.checkpointTime.rawValue) private var checkpointTime: Int = 30 * 60
    @AppStorage(StorageKey.badAppTime.rawValue) private var badAppTime: Int = 0

    @State private var showSettings: Bool = false
    @State private var showSheet: Bool = false
    @State private var timeRemaining: Int = 0
    @State private var remainingTimeBoxOffset: CGFloat = 0

    @State private var goodContext: DeviceActivityReport.Context = .init(rawValue: "GoodActivity")
    @State private var badContext: DeviceActivityReport.Context = .init(rawValue: "BadActivity")
    @State private var goodFilter: DeviceActivityFilter?
    @State private var badFilter: DeviceActivityFilter?

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Usage Time")) {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            #if DEBUG
                            GoodActivityTotalTimeView(activityReport: "4000")
                            BadActivityTotalTimeView(activityReport: "2500")
                            #else
                            DeviceActivityReport(goodContext, filter: goodFilter!)
                            DeviceActivityReport(badContext, filter: badFilter!)
                            #endif
                        }

                        CheckpointTimeView(checkpoint: 30*60)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Calculate Checkpoint Time")) {
                    Button {
                        withAnimation {
                            showSheet.toggle()
                        }
                    } label: {
                        if timeRemaining == 0 {
                            ActivityCardView(
                                title: "Progress to Next Checkpoint",
                                duration: "Press to Calculate",
                                primaryColor: .orange
                            )
                        } else {
                            ActivityCardView(
                                title: "Progress to Next Checkpoint",
                                duration: "\(formatDuration(seconds: timeRemaining))",
                                primaryColor: .yellow
                            )
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Welcome, \(userName)")
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showSettings.toggle()
                        }
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundStyle(.gray)
                            .padding(10)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsMain()
                    .presentationDetents([.large])
                    .presentationBackground(.thinMaterial)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSheet) {
                TimePickerView(checkpointTimeInSeconds: checkpointTime, timeRemaining: $timeRemaining)
                    .presentationDetents([.fraction(0.5)])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.thinMaterial)
            }
        }
    }
}

#Preview {
    ZStack {
        AppBackground()
            .edgesIgnoringSafeArea(.all)  // Ensure background covers the full screen
        Home()
            .environment(DeviceActivityModel())
    }
}
