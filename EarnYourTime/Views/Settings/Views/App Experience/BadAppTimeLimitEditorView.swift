//
//  BadAppTimeLimitEditorView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/9/25.
//

import SwiftUI

struct BadAppTimeLimitEditorView: View {
    var updateMonitoring: Bool = true
    var askConfirmation: Bool = true
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var showAlert: Bool = false
    @State private var showConfirmation: Bool = false
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage(StorageKey.checkpointTime.rawValue) var checkpointTime: Int = 0
    @AppStorage(StorageKey.badAppTime.rawValue) var badAppTimeLimit: Int = 0
    @Environment(\.dismiss) var dismiss
    
    private var timeInSeconds: Int {
        return hours * 3600 + minutes * 60
    }
    
    var body: some View {
        NavigationView {
            Form {
                TimePicker(days: .constant(-1), hours: $hours, minutes: $minutes)
            }
            .onAppear {
                minutes = Int(badAppTimeLimit / 60)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "timer")
                            .fontWeight(.bold)
                        Group {
                            Text("Set ") + Text("Bad").foregroundStyle(Color.bad) + Text(" App Time Limit")
                        }
                            .font(.title.bold())
                    }
                    .padding(.top, 50)
                }
            }
            .safeAreaInset(edge: .bottom) {
                ActionButton(disabled: timeInSeconds == 0) {
                    // check inputed time
                    if timeInSeconds > checkpointTime {
                        showAlert = true
                    } else {
                        badAppTimeLimit = timeInSeconds
                        
                        // check if monitoring should be updated
                        if updateMonitoring {
                            
                            //check if confirmation is needed (ie. not in onboarding view)
                            if askConfirmation {
                                showConfirmation = true
                            } else {
                                deviceActivityModel.updateMonitoring()
                                dismiss()
                            }
                        } else {
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("Bad, Bad App Time Limit", isPresented: $showAlert) {} message: {
            Text("Your Bad App Time Limit has to be less than or equal to \(formatDuration(seconds: checkpointTime)) (your checkpoint time).")
        }
        .alert("Confirmation", isPresented: $showConfirmation) {
            Button("Cancel", role: .cancel) {}
            
            Button("Ok") {
                deviceActivityModel.updateMonitoring()
                dismiss()
            }
        } message: {
            Text("Updating this will reset monitoring using today’s data, which might temporarily skew your stats. Things should normalize within a day.")
        }
    }
}

#Preview {
    BadAppTimeLimitEditorView()
        .environment(DeviceActivityModel())
}
