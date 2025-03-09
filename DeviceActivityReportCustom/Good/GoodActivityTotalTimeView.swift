//
//  GoodActivityTotalTimeView.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings


struct GoodActivityTotalTimeView: View {
    var activityReport: String
    @State var progress: Double?
    var thickness: CGFloat = 20 // Thickness of the ring
    var primaryColor: Color = .good

    var body: some View {
        VStack {
            Text("Good App Time")
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(Color.accent)
                
            ZStack {
                Circle()
                    .stroke(
                        primaryColor,
                        style: StrokeStyle(lineWidth: thickness, lineCap: .round)
                    )
                
                Text("\(formatDuration(seconds: Int(progress ?? 0.0)))")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(primaryColor)
            }
            .padding(thickness / 2) // Prevent cropping
            .onAppear {
                progress = Double(activityReport)
            }
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
#Preview {
    GoodActivityTotalTimeView(activityReport: "100")
}
