//
//  VacationModeView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

// TODO: implement starting/stopping monitoring

import SwiftUI

struct VacationModeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
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
                SaveButton(disabled: days == 0 && hours == 0 && minutes == 0) {
                    wasSaved = true
                    vacationMode = true
                    deviceActivityModel.startVacationMode(duration)
                    dismiss()
                }
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
