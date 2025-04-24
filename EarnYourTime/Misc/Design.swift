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
                textColor = (colorScheme == .dark ? Color.white : .black)
                buttonColor = (colorScheme == .dark ? Color.black : .white)
            } else {
                textColor = (colorScheme == .dark ? Color.white : .black)
                buttonColor = color!
            }
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .padding()
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
    
    @AppStorage(StorageKey.isMonitoring.rawValue) private var isMonitoring = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? .white : .black)

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
//        .disabledOverlay(isDisabled: !isMonitoring)
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
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(color.opacity(0.12))
                    }
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

struct DisabledOverlayModifier: ViewModifier {
    let isDisabled: Bool
    let message: String?

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isDisabled)
//                .blur(radius: isDisabled ? 2 : 0)

            if isDisabled {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .overlay(DiagonalLines().clipShape(RoundedRectangle(cornerRadius: 16)))

                    if let message = message {
                        Text(message)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.7)))
                    }
                }
//                .padding(-10) // Adjust for better appearance
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .animation(.easeInOut, value: isDisabled)
    }
}

// Diagonal Lines Shape
struct DiagonalLines: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 30
            let color = Color.white.opacity(0.3)

            for x in stride(from: -size.height, to: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: -10))
                path.addLine(to: CGPoint(x: x + size.height + 5, y: size.height + 10))
                context.stroke(path, with: .color(color), lineWidth: 10)
            }
        }
    }
}

extension View {
    func disabledOverlay(isDisabled: Bool, message: String? = nil) -> some View {
        modifier(DisabledOverlayModifier(isDisabled: isDisabled, message: message))
    }
}

struct PermissionsArrowCheck: View {
    var conditional: Bool
    
    var body: some View {
        if conditional {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.white, .green)
                .font(.title3)
        } else {
            Image(systemName: "arrow.right")
                .font(.title3)
        }
    }
}
