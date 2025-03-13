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
        ActivityCardView(
            title: "Checkpoint",
            duration: formatDuration(seconds: checkpoint),
            primaryColor: .blue
        )
    }
}

#Preview {
    CheckpointTimeView(checkpoint: 30*60)
}
