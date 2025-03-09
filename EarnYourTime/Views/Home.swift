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
    @AppStorage("checkpointTime") private var checkpointTime: Int = 30 * 60
    @AppStorage("badAppTime") private var badAppTime: Int = 0

    @State private var showSettings: Bool = false
    @State private var showSheet: Bool = false
    @State private var timeRemaining: Int = 0
    @State private var remainingTimeBoxOffset: CGFloat = 0

    @State private var goodContext: DeviceActivityReport.Context = .init(rawValue: "GoodActivity")
    @State private var badContext: DeviceActivityReport.Context = .init(rawValue: "BadActivity")
    @State private var goodFilter: DeviceActivityFilter?
    @State private var badFilter: DeviceActivityFilter?

    var quote: some View {
        VStack(spacing: 4) {
            (Text("For every ") +
             Text(formatDuration(seconds: checkpointTime)).foregroundColor(.blue) +
             Text(" you spend on ") +
             Text("good apps").foregroundColor(.green) +
             Text(",") +
             Text(" you get to spend ") +
             Text(formatDuration(seconds: badAppTime)).foregroundColor(.red) +
             Text(" on ") +
             Text("bad apps").foregroundColor(.red))
        }
        .foregroundStyle(Color.white)
        .font(.system(size: 17, weight: .medium))
        .multilineTextAlignment(.center)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.5), lineWidth: 2))
                .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
    
    var header: some View {
        VStack {
            Text("Earn Your Time")
                .font(.system(size: 34, weight: .bold))
                .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
            Divider()
                .background(Color.white.opacity(0.3))
            Spacer()
        }
    }

    var body: some View {
        ZStack {
            header
            
            VStack(spacing: 20) {
//                quote
                
                HStack(spacing: 15) {
                    if let filter = goodFilter {
                        DeviceActivityReport(goodContext, filter: filter)
                    } else {
                        GoodActivityTotalTimeView(activityReport: "4000")
                    }

                    if let filter = badFilter {
                        DeviceActivityReport(badContext, filter: filter)
                    } else {
                        BadActivityTotalTimeView(activityReport: "2500")
                    }
                }

                CheckpointTimeView(checkpoint: checkpointTime)

                Button {
                    withAnimation {
                        showSheet.toggle()
                    }
                } label: {
                    Group {
                        if timeRemaining == 0 {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 25, weight: .medium))
                                    .foregroundColor(.yellow)
                                Text("Click to find out how long to your next checkpoint")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(.yellow)
                            }
                        } else {
                            Text("You need **\(formatDuration(seconds: timeRemaining))** to reach your next checkpoint")
                                .font(.system(size: 18, weight: .medium))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.yellow)
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.4))
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.5), lineWidth: 2))
                            .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                }

                Button {
                    withAnimation {
                        showSettings.toggle()
                    }
                } label: {
                    Image(systemName: "gear")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundStyle(Color.white)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.4))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.5), lineWidth: 2))
                                .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                }
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsMain()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showSheet) {
            TimePickerView(checkpointTimeInSeconds: checkpointTime, timeRemaining: $timeRemaining)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .padding()
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
