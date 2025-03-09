//
//  Design.swift
//  EarnYourTime
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

struct AppColorScheme {
    static let good = Color(hex: "4CAF50")
    static let bad = Color(hex: "D33F40")
    static let accent = Color(hex: "484848")
}

extension Color {
    static let good = AppColorScheme.good
    static let bad = AppColorScheme.bad
    static let accent = AppColorScheme.accent
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

struct SaveButton: View {    
    var disabled: Bool
    var action: (() -> Void)? = nil
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            action?()
        } label: {
            Text("Save")
                .foregroundStyle(colorScheme == .dark ? Color.black : .white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(colorScheme == .dark ? Color.white : .black)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .padding()
    }
}

struct SettingsListItem: View {
    let text: String
    let systemImage: String
    var action: (() -> Void)? = nil

    
    var body: some View {
        Button {
            action?()
        } label: {
            HStack {
                HStack {
                    Image(systemName: systemImage)
                    Text(text)
                }
                Spacer()
                Image(systemName: "arrow.right")
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        AppBackground()
        SettingsListItem(text: "Checkpoint Time", systemImage: "flag.checkered")
    }
}
