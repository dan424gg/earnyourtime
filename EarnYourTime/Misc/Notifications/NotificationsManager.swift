//
//  NotificationsManager.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation
import UserNotifications

class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    func setupNotificationDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }
    
    func isSetupNotificationDelegate() -> Bool {
        if UNUserNotificationCenter.current().delegate === self {
            print("The notification center delegate is correctly set.")
            return true
        } else {
            print("The notification center delegate is not set to the expected instance.")
            return false
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
            case "snoozeAction":
                // Handle snooze action
                print("found a snooze action")
                break
                    
            case "cancelAction":
                // Handle cancel action
                print("found a cancel action")
                break
                    
            default:
                // Handle default action
                break
        }

        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound]) // Show the notification as a banner with sound
    }
}
