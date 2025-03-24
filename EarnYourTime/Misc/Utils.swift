//
//  Utils.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import SwiftUI

// Extension for defining event names.
extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let checkpoint = Self("checkpoint")
    static let goodAppMonitor = Self("goodAppMonitor")
    static let badAppMonitor = Self("badAppMonitor")
}

// Start monitoring device activity.
func startMonitoring(includesPastActivity: Bool = false) throws {
    // Persistent storage using @AppStorage to store settings.
    @AppStorage(StorageKey.badAppTime.rawValue) var badAppTime: Int = -1
    @AppStorage(StorageKey.checkpointTime.rawValue) var checkpointTime: Int = -1
    @AppStorage(StorageKey.goodFamilySelections.rawValue) var goodSelectionsStorage: Data = Data()
    @AppStorage(StorageKey.badFamilySelections.rawValue) var badSelectionsStorage: Data = Data()
    
    let goodSelections: FamilyActivitySelection = decode(FamilyActivitySelection.self, from: goodSelectionsStorage, defaultValue: FamilyActivitySelection())
    let badSelections: FamilyActivitySelection = decode(FamilyActivitySelection.self, from: badSelectionsStorage, defaultValue: FamilyActivitySelection())
    let center = DeviceActivityCenter()
    
    print("Bad selections: \(badSelections.applications.count) apps, \(badSelections.webDomains.count) web domains")
    print("Good selections: \(goodSelections.applications.count) apps, \(goodSelections.webDomains.count) web domains")
    print("Checkpoint time: \(checkpointTime) minutes, Bad app time: \(badAppTime) minutes")
    
    let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
        .checkpoint: DeviceActivityEvent(
            applications: goodSelections.applicationTokens,
            categories: goodSelections.categoryTokens,
            webDomains: goodSelections.webDomainTokens,
            threshold: DateComponents(minute: checkpointTime),
            includesPastActivity: includesPastActivity
        ),
        .badAppMonitor: DeviceActivityEvent(
            applications: badSelections.applicationTokens,
            categories: badSelections.categoryTokens,
            webDomains: badSelections.webDomainTokens,
            threshold: DateComponents(minute: badAppTime),
            includesPastActivity: includesPastActivity
        ),
    ]
    
    let schedule: DeviceActivitySchedule = DeviceActivitySchedule(
        intervalStart: DateComponents(hour: 0, minute: 0),
        intervalEnd: DateComponents(hour: 23, minute: 59),
        repeats: true
    )
    
    try center.startMonitoring(.daily, during: schedule, events: events)
    print("Started monitoring at \(Calendar.current.component(.minute, from: Date()))")
}

// Stop monitoring device activity.
func stopMonitoring() {
    let store = ManagedSettingsStore()
    let center = DeviceActivityCenter()
    
    store.shield.applications = nil
    store.shield.webDomains = nil
    center.stopMonitoring()
    
    print("Stopped monitoring")
}

// Refresh the monitoring settings with optional updates.
func updateMonitoring() {
    stopMonitoring()

    // Restart monitoring with updated settings.
    do {
        try startMonitoring(includesPastActivity: true)
    } catch {
        print("Failed to restart monitoring: \(error)")
    }
}

func decode<T: Decodable>(_ type: T.Type, from data: Data, defaultValue: T) -> T {
    (try? JSONDecoder().decode(T.self, from: data)) ?? defaultValue
}

func encode<T: Encodable>(_ data: T) -> Data {
    (try? JSONEncoder().encode(data)) ?? Data()
}

func getAppVersion() -> String {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return appVersion
    }
    return "Unknown"
}

func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func fullDayInterval(for date: Date) -> DateInterval? {
    let calendar = Calendar.current

    // Get the start of the day
    let startOfDay = calendar.startOfDay(for: date)

    // Calculate the end of the day by adding one day and subtracting a second
    guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
        return nil
    }

    // Create and return the DateInterval
    return DateInterval(start: startOfDay, end: endOfDay)
}

func getWidthOfScreen() -> CGFloat {
    return UIScreen.main.bounds.width
}

func getHeightOfScreen(includingSafeArea: Bool = false) -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    
    // Ensure there's at least one window scene available
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        // Get the first window from the windowScene
        if let window = windowScene.windows.first {
            let safeAreaInsets = window.safeAreaInsets
            
            // If including the safe area, return the full screen height
            if includingSafeArea {
                return screenHeight
            } else {
                // If excluding the safe area, subtract the top and bottom safe area insets
                return screenHeight - safeAreaInsets.top - safeAreaInsets.bottom
            }
        }
    }

    // Default to the screen height if the safe area insets cannot be determined
    return screenHeight
}

func formatDuration(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}

struct OptionBackground: ViewModifier {
    var width: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding([.top, .bottom], 5)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray, lineWidth: 3)
                    .frame(width: width * 0.8)
            }
    }
}

extension View {
    func optionBackground(_ width: CGFloat) -> some View {
        modifier(OptionBackground(width: width))
    }
}

let textFieldNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    @Binding var size: CGSize

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear
                    .preference(key: ViewSizeKey.self, value: proxy.size)
            })
            .onPreferenceChange(ViewSizeKey.self) { newSize in
                size = newSize
            }
    }
}

extension View {
    func measureSize(_ size: Binding<CGSize>) -> some View {
        self.modifier(SizeModifier(size: size))
    }
}

struct CaptureSizeModifier: ViewModifier {
    @Binding var referenceSize: CGSize
    @State private var captured: Bool = false

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        if !captured {
                            let height = proxy.size.height
                            let width = proxy.size.width
                            
                            referenceSize = CGSize(width: width, height: height)
                            captured = true
                        }
                    }
            })
    }
}

extension View {
    func captureSizeOnce(to size: Binding<CGSize>) -> some View {
        self.modifier(CaptureSizeModifier(referenceSize: size))
    }
}

func openEmail(email: String, subject: String, body: String = "") {
    let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    
    if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
        UIApplication.shared.open(url)
    }
}
