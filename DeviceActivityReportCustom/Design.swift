//
//  Design.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: Double
        switch hex.count {
        case 6: // RGB (No Alpha)
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255,
                1.0
            )
        case 8: // ARGB or RGBA
            (r, g, b, a) = (
                Double((int >> 16) & 0xFF) / 255,
                Double((int >> 8) & 0xFF) / 255,
                Double(int & 0xFF) / 255,
                Double((int >> 24) & 0xFF) / 255
            )
        default:
            (r, g, b, a) = (1, 1, 1, 1) // Default to white if invalid
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(
                stops: [
                    .init(
                        color: Color.good.opacity(0.2),
                        location: 0.1
                    ),
                    .init(
                        color: Color.bad.opacity(0.3),
                        location: 1.0
                    )
                ]
            ),
            startPoint: .leading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct ActivityCardView: View {
    var title: String
    var duration: String
    var primaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(primaryColor)
                .hidden()

            Text(duration)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(primaryColor)
                )
        }
        .padding()
        .padding(2)
    }
}

// make sure to apply any changes here to EarnYourTime/Misc/Design
struct AppColorScheme {
    static let good = Color(hex: "4CAF50")
    static let bad = Color(hex: "D33F40")
    static let accent = Color(hex: "484848")
}

// make sure to apply any changes here to EarnYourTime/Misc/Design
extension Color {
    static let good = AppColorScheme.good
    static let bad = AppColorScheme.bad
    static let accent = AppColorScheme.accent
}
