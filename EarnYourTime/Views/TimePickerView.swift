//
//  TimePickerView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

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
                Text("What's Your ") + Text("Good").foregroundStyle(Color.good) + Text(" Time?")
            }
            .font(.title2.bold())
            .foregroundStyle(.white)
            .padding()
                            
            TimePicker(hours: $goodHours, minutes: $goodMinutes)
                .onChange(of: [goodHours, goodMinutes]) {
                    if (goodHours != 0 && goodMinutes != 0) || goodMinutes != 0 {
                        withAnimation {
                            if checkpointTimeInSeconds == 0 {
                                timeRemaining = 0  
                            } else {
                                timeRemaining = checkpointTimeInSeconds - (goodTimeInSeconds % checkpointTimeInSeconds)
                            }
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
            if hours != -1 {
                Picker("Hours", selection: $hours) {
                    ForEach(0..<24, id: \.self) { Text("\($0) h") }
                }
                .pickerStyle(.wheel)
            }
            
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
