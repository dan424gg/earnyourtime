//
//  CheckpointTimeView.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI

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

#Preview {
    CheckpointTimeView(checkpoint: 30*60)
}
