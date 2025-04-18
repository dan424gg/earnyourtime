//
//  VacationModeView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

// TODO: implement starting/stopping monitoring

import SwiftUI
import BackgroundTasks

struct VacationModeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = 0
    
    @Binding var temp_vacationMode: Bool
    
    @State var wasSaved: Bool = false
    @State private var days: Int = 0
    @State private var hours: Int = 0
    @State private var minutes: Int = 0

    
    var duration: Double {
        return Double((days * 24 * 3600) + (hours * 3600) + (minutes * 60))
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
                VStack(spacing: -20) {
                    ActionButton(disabled: !vacationMode, text: "Cancel", color: .red) {
                        cancelVacationMode()
                        dismiss()
                    }
                    
                    ActionButton(disabled: days == 0 && hours == 0 && minutes == 0) {
                        let endDate = Date().addingTimeInterval(duration).timeIntervalSince1970
                        vacationModeEndDate = endDate
                        
                        vacationMode = true
                        
                        startVacationMode()
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
    func cancelVacationMode() {
        vacationModeEndDate = 0
        vacationMode = false
                
        do {
            try deviceActivityModel.startMonitoring()
        } catch {}
    }

    func cancelScheduledVacationNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["VacationModeEnd"])
        print("Canceled Vacation Mode notification")
    }

    func startVacationMode() {
        deviceActivityModel.stopMonitoring()
        scheduleVacationEndNotification()
        // start scheduled monitoring
    }
}

#Preview {
    VacationModeView(temp_vacationMode: .constant(false))
        .environment(DeviceActivityModel())
}
