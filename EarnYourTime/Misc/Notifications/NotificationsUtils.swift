//
//  NotificationsUtils.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import SwiftData
import UserNotifications


func sendNotification(title: String, subtitle: String, waitDuration: Double = 5.0, repeats: Bool = false) async {
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.sound = UNNotificationSound.default
    content.interruptionLevel = .critical // set notification severity level
    content.badge = 0 // manually set badge number for app

    /// Set different actions for the user to take on the notification
    let action1 = UNNotificationAction(identifier: "snoozeAction", title: "Snooze", options: [])
    let action2 = UNNotificationAction(identifier: "cancelAction", title: "Cancel", options: [.destructive])

    let category = UNNotificationCategory(identifier: "meetingCategory", actions: [action1, action2], intentIdentifiers: [], options: [])

    UNUserNotificationCenter.current().setNotificationCategories([category])

    content.categoryIdentifier = "meetingCategory"
    /// ***
    
    print("\nsending the following notification: \n\(title)\n\(subtitle)\n\(waitDuration)")

    // show this notification five seconds from now
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: waitDuration, repeats: repeats)

    // choose a random identifier
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    // schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    do {
        try await notificationCenter.add(request)
    } catch {
        print(error)
    }
}

func scheduleVacationEndNotification() {
    @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = 0
    
    let content = UNMutableNotificationContent()
    content.title = "Vacation Mode Ended"
    content.body = "Time tracking has resumed."
    content.sound = .default

    let triggerDate = Date(timeIntervalSince1970: vacationModeEndDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate), repeats: false)

    let request = UNNotificationRequest(identifier: "VacationModeEnd", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Failed to schedule notification: \(error)")
        }
    }
}
