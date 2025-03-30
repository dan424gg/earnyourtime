//
//  Design.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation
import SwiftUI


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

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

struct ActionButton: View {    
    var disabled: Bool
    var text: String = "Save"
    var color: Color?
    var action: (() -> Void)? = nil
    
    @State private var textColor: Color = .white
    @State private var buttonColor: Color = .black

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button {
            action?()
        } label: {
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(textColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(buttonColor)
                )
        }
        .onAppear {
            if color == nil {
                textColor = (colorScheme == .dark ? Color.black : .white)
                buttonColor = (colorScheme == .dark ? Color.white : .black)
            } else {
                textColor = (colorScheme == .dark ? Color.black : .white)
                buttonColor = color!
            }
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .padding()
    }
}

#Preview {
    ActionButton(disabled: false, text: "Cancel", color: .red) {
        // something
    }
}

struct SettingsName: View {
    @Binding var name: String
    @State var tempName: String = ""
    let text: String
    let systemImage: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: systemImage)
                Text(text)
            }
            Spacer()
            TextField("Name", text: $tempName)
                .multilineTextAlignment(.trailing)
                .submitLabel(.done)
                .onSubmit {
                    name = tempName
                }
        }
        .onAppear {
            tempName = name
        }
    }
}

struct SettingsButton: View {
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
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct SettingsAppearancePicker: View {
    @Binding var colorScheme: String
    let text: String
    let systemImage: String

    var body: some View {
        ZStack {
            HStack {
                HStack {
                    Image(systemName: systemImage)
                    Text(text)
                }
                Spacer()
                Picker("Theme", selection: $colorScheme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(SegmentedPickerStyle())
//                .padding(.leading)
            }
        }
    }
}

struct SettingsToggle: View {
    @Binding var state: Bool
    let text: String
    let systemImage: String

    var body: some View {
        ZStack {
            HStack {
                HStack {
                    Image(systemName: systemImage)
                    Text(text)
                }
                Spacer()
                Toggle("", isOn: $state)
            }
        }
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

            Text(duration)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(primaryColor.opacity(0.8))
                )
        }
        .activityBackground(color: primaryColor)
        .padding(2)
    }
}

struct GoodActivityTotalTimeView: View {
    var activityReport: String
    @State private var progress: Double?

    var body: some View {
        ActivityCardView(
            title: "Good",
            duration: formatDuration(seconds: Int(progress ?? 0.0)),
            primaryColor: .green
        )
        .onAppear {
            progress = Double(activityReport)
        }
    }
}

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

struct ActivityCardBackground: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(color.opacity(0.7), lineWidth: 2)
                    )
            )
    }
}

extension View {
    func activityBackground(color: Color) -> some View {
        self.modifier(ActivityCardBackground(color: color))
    }
}
