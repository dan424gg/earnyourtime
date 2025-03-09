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
                .shadow(color: primaryColor.opacity(0.3), radius: 10, x: 0, y: 5)
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

struct CheckpointTimeView: View {
    var checkpoint: Int
    var primaryColor: Color = .blue
    
    var body: some View {
        VStack {
            Text("Checkpoint Time")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            
            Text(formatDuration(seconds: checkpoint))
                .font(.title.bold())
                .foregroundStyle(primaryColor)
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
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.white.opacity(0.1), radius: 8, x: 0, y: 4)
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
                Text("You need **\(formatDuration(seconds: $timeRemaining.wrappedValue))** more to reach your checkpoint!")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .foregroundStyle(.yellow)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.black.opacity(0.3)))
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


struct TimePickerView: View {
    var checkpointTimeInSeconds: Int
    @Binding var timeRemaining: Int
    
    @State private var goodHours: Int = 0
    @State private var goodMinutes: Int = 0
    
    var goodTimeInSeconds: Int {
        (goodHours * 3600) + (goodMinutes * 60)
    }
    
    var body: some View {
        VStack {
            Group {
                Text("Set Your ") + Text("Good").foregroundStyle(Color.good) + Text(" Time")
            }
            .font(.title2.bold())
            .foregroundStyle(.white)
            .padding()
                            
            TimePicker(hours: $goodHours, minutes: $goodMinutes)
                .onChange(of: [goodHours, goodMinutes]) {
                    if (goodHours != 0 && goodMinutes != 0) || goodMinutes != 0 {
                        withAnimation {
                            timeRemaining = checkpointTimeInSeconds - (goodTimeInSeconds % checkpointTimeInSeconds)
                        }
                    }
                }
        }
        .padding()
    }
}

struct TimePicker: View {
    @Binding var hours: Int
    @Binding var minutes: Int
    
    var body: some View {
        HStack {
            Picker("Hours", selection: $hours) {
                ForEach(0..<24, id: \.self) { Text("\($0) h") }
            }
            .pickerStyle(.wheel)
            
            Picker("Minutes", selection: $minutes) {
                ForEach(0..<60, id: \.self) { Text("\($0) m") }
            }
            .pickerStyle(.wheel)
        }
    }
}

#Preview {
    ZStack {
        AppBackground()
        TimePickerView(checkpointTimeInSeconds: 15*60, timeRemaining: .constant(50))
    }
}

#Preview {
    ZStack {
        AppBackground()
        Testing()
    }
}



//struct TimePickerSheet: View {
//    @Binding var selectedHour: Int
//    @Binding var selectedMinute: Int
//    let goodOrBad: GoodOrBad
//    let hours = Array(0..<24) // 0 to 23 for hours
//    let minutes = Array(0..<60) // 0 to 59 for minutes
//
//    var body: some View {
//        VStack {
//            Group {
//                Text("Select your ")
//                + Text("\(goodOrBad.rawValue.lowercased())").foregroundStyle(goodOrBad == .Good ? Color.good : Color.bad)
//                + Text(" app time:")
//            }
//            .font(.system(size: 25, weight: .semibold))
//            .foregroundStyle(Color.accent)
//
//            HStack {
//                Picker("Hour", selection: $selectedHour) {
//                    ForEach(hours, id: \.self) { hour in
//                        Text("\(String(format: "%02d", hour)) h")
//                            .tag(hour)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .frame(width: 100)
//
//                Picker("Minute", selection: $selectedMinute) {
//                    ForEach(minutes, id: \.self) { minute in
//                        Text("\(String(format: "%02d", minute)) m")
//                            .tag(minute)
//                    }
//                }
//                .pickerStyle(WheelPickerStyle())
//                .frame(width: 100)
//            }
//            .frame(height: 150)
//        }
//        .padding()
//    }
//}
//
//enum GoodOrBad: String {
//    case Good
//    case Bad
//    case none
//}
//
//func convertToSeconds(hours: Int, minutes: Int) -> Int {
//    return (hours * 60 * 60) + (minutes * 60)
//}
//
//func smartModulus(_ first: Int, _ second: Int) -> Int {
//    if second == 0 {
//        return 0
//    }
//
//    return first % second
//}
//
//struct RemainingTimeCalculator: View {
//    @State private var goodOrBad: GoodOrBad = .none
//    @State private var selectedBadHour = 0
//    @State private var selectedBadMinute = 0
//    @State private var selectedGoodHour = 0
//    @State private var selectedGoodMinute = 0
//    @State private var showSheet = false // State to control sheet visibility
//    let hours = Array(0..<24) // 0 to 23 for hours
//    let minutes = Array(0..<60) // 0 to 59 for minutes
//
//
//    var body: some View {
//        HStack {
//            Button(action: {
//                goodOrBad = .Good
//                showSheet.toggle() // Present the sheet when the button is pressed
//            }) {
//                Text("\(selectedGoodHour) h \(selectedGoodMinute) m")
//                    .font(.system(size: 20, weight: .bold))
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.good, lineWidth: 5)
//                            .fill(Color.good.opacity(0.4))
//                    }
//                    .foregroundColor(.white)
//            }
//
//            Text("%")
//                .font(.system(size: 25, weight: .bold))
//                .padding()
//                .foregroundStyle(Color.accent)
//
//            Button(action: {
//                goodOrBad = .Bad
//                showSheet.toggle() // Present the sheet when the button is pressed
//            }) {
//                Text("\(selectedBadHour) h \(selectedBadMinute) m")
//                    .font(.system(size: 20, weight: .bold))
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius: 5)
//                            .stroke(Color.bad, lineWidth: 5)
//                            .fill(Color.bad.opacity(0.4))
//                    }
//                    .foregroundColor(.white)
//            }
//
//            Text("=")
//                .font(.system(size: 25, weight: .bold))
//                .padding()
//                .foregroundStyle(Color.accent)
//
//            Text("\(formatDuration(seconds: smartModulus(convertToSeconds(hours: selectedBadHour, minutes: selectedBadMinute), convertToSeconds(hours: selectedGoodHour, minutes: selectedGoodMinute))))")
//                .font(.system(size: 20, weight: .bold))
//                .padding()
//                .background {
//                    RoundedRectangle(cornerRadius: 5)
//                        .stroke(Color.accent, lineWidth: 5)
//                        .fill(Color.accent.opacity(0.4))
//                }
//                .foregroundColor(.white)
//
//
//        }
//        .padding()
//        .onChange(of: showSheet) {
//            if !showSheet {
//                goodOrBad = .none
//            }
//        }
//        .sheet(isPresented: $showSheet) {
//            if goodOrBad == .Good {
//                // The sheet content goes here
//                TimePickerSheet(selectedHour: $selectedGoodHour, selectedMinute: $selectedGoodMinute, goodOrBad: .Good)
//                    .presentationDetents([.fraction(0.4)])
//                    .presentationDragIndicator(.hidden)
//                    .presentationBackground(.ultraThinMaterial)
//
//            } else if goodOrBad == .Bad {
//                // The sheet content goes here
//                TimePickerSheet(selectedHour: $selectedBadHour, selectedMinute: $selectedBadMinute, goodOrBad: .Bad)
//                    .presentationDetents([.fraction(0.4)])
//                    .presentationDragIndicator(.hidden)
//                    .presentationBackground(.ultraThinMaterial)
//            }
//        }
//    }
//}
//
//#Preview {
//    ZStack {
//        AppBackground()
//        RemainingTimeCalculator()
//    }
//}
