//
//  CheckpointTimeEditorView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

struct CheckpointTimeEditorView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
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
                SaveButton(disabled: timeInSeconds == 0) {
                    checkpointTime = timeInSeconds
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    CheckpointTimeEditorView()
}
