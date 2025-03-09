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
    @State var progress: Double?
    var primaryColor: Color = .bad

    var body: some View {
        VStack {
            Text("Bad App Time")
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.bottom, 5)
            
            Text(formatDuration(seconds: Int(progress ?? 0.0)))
                .font(.title.bold())
                .foregroundStyle(primaryColor)
        }
        .onAppear {
            progress = Double(activityReport)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(primaryColor.opacity(0.7), lineWidth: 2)
                )
                .shadow(color: primaryColor.opacity(0.4), radius: 10, x: 0, y: 5)
        )
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    BadActivityTotalTimeView(activityReport: "100")
}

