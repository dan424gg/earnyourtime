//
//  testing.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

func formatDuration(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}

struct ActivityCardView: View {
    var title: String
    var duration: String
    var primaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(primaryColor)

            Text(duration)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(primaryColor.opacity(0.8))
//                        .shadow(color: primaryColor.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(primaryColor.opacity(0.7), lineWidth: 2)
                )
//                .shadow(color: primaryColor.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

struct GoodActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?

    var body: some View {
        ActivityCardView(
            title: "Good",
            duration: formatDuration(seconds: Int(progress ?? 0.0)),
            primaryColor: .green
        )
        .onAppear {
            progress = Double(activityReport)
        }
    }
}

struct BadActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?

    var body: some View {
        ActivityCardView(
            title: "Bad",
            duration: formatDuration(seconds: Int(progress ?? 0.0)),
            primaryColor: .red
        )
        .onAppear {
            progress = Double(activityReport)
        }
    }
}

struct Testing: View {
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
                            GoodActivityTotalTimeView(activityReport: "4000")
                            BadActivityTotalTimeView(activityReport: "2500")
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
    Testing()
        .environment(DeviceActivityModel())
}
