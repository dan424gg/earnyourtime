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

struct BadActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?
    var primaryColor: Color = .red
    
    var body: some View {
        VStack {
            Text("Bad App Time")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            
            Text(formatDuration(seconds: Int(progress ?? 0.0)))
                .font(.title.bold())
                .foregroundStyle(primaryColor)
        }
        .onAppear {
            progress = Double(activityReport)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(primaryColor.opacity(0.7), lineWidth: 2)
                )
                .shadow(color: primaryColor.opacity(0.4), radius: 10, x: 0, y: 5)
        )
    }
}

struct GoodActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?
    var primaryColor: Color = .green
    
    var body: some View {
        VStack {
            Text("Good App Time")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            
            Text(formatDuration(seconds: Int(progress ?? 0.0)))
                .font(.title.bold())
                .foregroundStyle(primaryColor)
        }
        .onAppear {
            progress = Double(activityReport)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(primaryColor.opacity(0.7), lineWidth: 2)
                )
                .shadow(color: primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

//struct CheckpointTimeView: View {
//    var checkpoint: Int
//    var primaryColor: Color = .blue
//    
//    var body: some View {
//        VStack {
//            Text("Checkpoint Time")
//                .font(.headline)
//                .foregroundStyle(.white)
//                .padding(.bottom, 5)
//            
//            Text(formatDuration(seconds: checkpoint))
//                .font(.title.bold())
//                .foregroundStyle(primaryColor)
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.black.opacity(0.4))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(primaryColor.opacity(0.7), lineWidth: 2)
//                )
//                .shadow(color: primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
//        )
//    }
//}

struct Testing: View {
    @State private var badAppTime: Int = 15 * 60
    @State private var checkpointTime: Int = 30 * 60
    
    @State private var showSheet: Bool = false
    @State private var timeRemaining: Int = 0
    
    
    var quote: some View {
        VStack(spacing: 4) {
            (Text("For every ") + Text(formatDuration(seconds: checkpointTime)).foregroundColor(.blue) + Text(" I spend on ") + Text("good apps").foregroundColor(.green) + Text(","))
            (Text("I get to spend ") + Text(formatDuration(seconds: badAppTime)).foregroundColor(.red) + Text(" on ") + Text("bad apps").foregroundColor(.red))
        }
        .foregroundStyle(Color.white)
        .font(.system(size: 18, weight: .medium))
        .multilineTextAlignment(.center)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
                .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                GoodActivityTotalTimeView(activityReport: "4000")
                BadActivityTotalTimeView(activityReport: "2500")
            }
            CheckpointTimeView(checkpoint: checkpointTime)
            
            quote
            
            Button {
                showSheet.toggle()
            } label: {
                Text("You need **\(formatDuration(seconds: $timeRemaining.wrappedValue))** to reach your next checkpoint!")
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.yellow)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
                            )
                            .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
            }

        }
        .sheet(isPresented: $showSheet) {
            TimePickerView(checkpointTimeInSeconds: checkpointTime, timeRemaining: $timeRemaining)
                .presentationDetents([.fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
        .padding()
    }
}
