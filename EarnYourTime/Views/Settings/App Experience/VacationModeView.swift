//
//  VacationModeView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

// TODO: implement starting/stopping monitoring

import SwiftUI

struct VacationModeView: View {
    @State var wasSaved: Bool = false
    @State private var timer: Timer?
    @State private var days: Int = 0
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Environment(\.dismiss) var dismiss
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
    
    private var futureDate: Date {
        let totalSeconds = (days * 24 * 3600) + (hours * 3600) + (minutes * 60)
        return Date().addingTimeInterval(TimeInterval(totalSeconds))
    }
    
    func scheduleTimer() {
        cancelTimer()
        
        let timeInterval = futureDate.timeIntervalSince(Date())
        guard timeInterval > 0 else { return }
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            // start monitoring again
        }
    }

    func cancelTimer() {
        timer?.invalidate()
        timer = nil
    }

    var body: some View {
        NavigationView {
            Form {
                Text("How long would you like full-access to your apps?")
                    .multilineTextAlignment(.center)

                TimePicker(days: $days, hours: $hours, minutes: $minutes)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "beach.umbrella")
                            .fontWeight(.bold)
                        Text("Vacation Mode")
                            .font(.title.bold())
                    }
                    .padding(.top, 50)
                }
            }
            .safeAreaInset(edge: .bottom) {
                SaveButton(disabled: false) {
                    wasSaved = true
                    
                    // stop monitoring
                    scheduleTimer()
                    
                    dismiss()
                }
            }
        }
        .onChange(of: vacationMode) { (old, new) in
            if old && !new {
                cancelTimer()
            }
        }
        .onDisappear {
            if !wasSaved {
                vacationMode = false
            }
        }
    }
}

#Preview {
    VacationModeView()
}
