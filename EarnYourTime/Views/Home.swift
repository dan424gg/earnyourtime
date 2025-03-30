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
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    
    @AppStorage(StorageKey.fullName.rawValue) var userName: String = "Dan"
    @AppStorage(StorageKey.checkpointTime.rawValue) private var checkpointTime: Int = 30 * 60
    @AppStorage(StorageKey.badAppTime.rawValue) private var badAppTime: Int = 0
    @AppStorage(StorageKey.goodFamilySelections.rawValue) private var goodFamilySelections: Data = Data()
    @AppStorage(StorageKey.badFamilySelections.rawValue) private var badFamilySelections: Data = Data()
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = 0

    @Namespace private var animationNamespace

    @State private var showSettings: Bool = false
    @State private var showSheet: Bool = false
    @State private var timeRemaining: Int = 0
    @State private var remainingTimeBoxOffset: CGFloat = 0
    @State private var showActivityView: Bool = false

    @State private var goodContext: DeviceActivityReport.Context = .init(rawValue: "GoodActivity")
    @State private var badContext: DeviceActivityReport.Context = .init(rawValue: "BadActivity")
    @State private var badFilter: DeviceActivityFilter?
    @State private var goodFilter: DeviceActivityFilter?
    
    @State private var activityReportSize: CGSize = .zero
        
    var deviceActivityView: some View {
        ZStack {
            // hacky way to get size of report
            HStack(spacing: 16) {
                BadActivityTotalTimeView(activityReport: "3000")
                
                GoodActivityTotalTimeView(activityReport: "4600")
                    .captureSizeOnce(to: $activityReportSize)
            }
            .opacity(0.0000000001)

            HStack(spacing: 16) {
//                #if DEBUG
//                GoodActivityTotalTimeView(activityReport: "4000")
//                BadActivityTotalTimeView(activityReport: "2500")
//                #else

                ZStack {
                    ActivityCardView(
                        title: "Good",
                        duration: "...",
                        primaryColor: .green
                    )
                    
                    if goodFilter != nil {
                        DeviceActivityReport(goodContext, filter: goodFilter!)
                            .opacity(showActivityView ? 1.0 : 0.0000001)
                    }
                }
                .frame(width: activityReportSize.width, height: activityReportSize.height)
                
                ZStack {
                    ActivityCardView(
                        title: "Bad",
                        duration: "...",
                        primaryColor: .red
                    )

                    if badFilter != nil {
                        DeviceActivityReport(badContext, filter: badFilter!)
                            .opacity(showActivityView ? 1.0 : 0.0000001)
                    }
                }
                .frame(width: activityReportSize.width, height: activityReportSize.height)
                
//                #endif
            }
            .task {
                showActivityView = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showActivityView = true
                }
            }
        }

    }
        
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 16) {
                        MonitoringStatusView()
                        deviceActivityView
                        CheckpointTimeView(checkpoint: checkpointTime)
                    }
                }
                .listRowBackground(Color.clear)
                
                Section {
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
                                primaryColor: .orange
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
        .onChange(of: [checkpointTime, badAppTime]) {
            deviceActivityModel.updateMonitoring()
        }
        // add a timer here to reset dayOne AppStorage to false, to enable normal usage
        .onChange(of: badFamilySelections, initial: true) {
            badFilter = DeviceActivityFilter(
                segment: .daily(
                    during: DateInterval(
                        // change here
                        start: .now,
                        end: Calendar.current.startOfDay(for: .now).addingTimeInterval(86400 - 1)
                    )
                ),
                devices: .init([.iPhone, .iPad]),
                applications: decode(FamilyActivitySelection.self, from: badFamilySelections, defaultValue: FamilyActivitySelection()).applicationTokens
            )
        }
        .onChange(of: goodFamilySelections, initial: true) {
            goodFilter = DeviceActivityFilter(
                segment: .daily(
                    during: DateInterval(
                        // change here
                        start: .now,
                        end: Calendar.current.startOfDay(for: .now).addingTimeInterval(86400 - 1)
                    )
                ),
                devices: .init([.iPhone, .iPad]),
                applications: decode(FamilyActivitySelection.self, from: goodFamilySelections, defaultValue: FamilyActivitySelection()).applicationTokens
            )
        }
    }
}

#Preview {
    ZStack {
        AppBackground()
            .edgesIgnoringSafeArea(.all)
        Home()
    }
    .environment(DeviceActivityModel())
}
