//
//  CheckpointTimeEditorView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

struct CheckpointTimeEditorView: View {
    var updateMonitoring: Bool = true
    
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @Environment(DeviceActivityModel.self) private var deviceActivityModel
    @AppStorage(StorageKey.checkpointTime.rawValue) var checkpointTime: Int = 0
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
                minutes = Int(checkpointTime / 60)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "flag.checkered")
                            .fontWeight(.bold)
                        Group {
                            Text("Set ") + Text("Checkpoint").foregroundStyle(Color.accentColor) + Text(" Time")
                        }
                            .font(.title.bold())
                    }
                    .padding(.top, 50)
                }
            }
            .safeAreaInset(edge: .bottom) {
                ActionButton(disabled: timeInSeconds == 0) {
                    checkpointTime = timeInSeconds
                    if updateMonitoring {
                        deviceActivityModel.updateMonitoring()
                    }
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CheckpointTimeEditorView()
        .environment(DeviceActivityModel())
}
