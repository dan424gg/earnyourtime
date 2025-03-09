//
//  Utils.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation
import SwiftUI

//func observeKeyboardNotifications() {
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//            keyboardHeight = keyboardFrame.height
//        }
//    }
//
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//        keyboardHeight = 0
//    }
//}

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
