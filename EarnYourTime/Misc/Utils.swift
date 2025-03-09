//
//  Utils.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation
import SwiftUI


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

func getHeightOfScreen() -> CGFloat {
    return UIScreen.main.bounds.height
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
