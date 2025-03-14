//
//  BadActivityTotalTimeView.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//


import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity


struct BadActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?

    var body: some View {
        ActivityCardView(
            title: "Bad",
            duration: formatDuration(seconds: Int(progress ?? 0.0)),
            primaryColor: .red
        )
        .onAppear {
            progress = Double(activityReport)
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    BadActivityTotalTimeView(activityReport: "100")
}

