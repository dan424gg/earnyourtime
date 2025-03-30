//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import DeviceActivity
import ManagedSettings
import UserNotifications


func sendNotification(title: String, subtitle: String, waitDuration: Double = 1.0, repeats: Bool = false) async {
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


// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        store.shield.applications = nil
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        if event == DeviceActivityEvent.Name("checkpoint") {
            /// if we reach the goodAppMonitor threshold, we want to increase the badAppMonitor's threshold by the incrementHack.threshold
            let events = DeviceActivityCenter().events(for: activity)
            
            // get activity schedule
            if
                let schedule = DeviceActivityCenter().schedule(for: activity),
//                let goodAppEvent = events[DeviceActivityEvent.Name("goodAppMonitor")],
                let badAppEvent = events[DeviceActivityEvent.Name("badAppMonitor")],
                let checkpointEvent = events[DeviceActivityEvent.Name("checkpoint")]
            {
                
                // get existing threshold
                let oldThreshold = badAppEvent.threshold.minute
                
                // get incrementHack threshold
                let incrementThreshold = checkpointEvent.threshold.minute
                
                // update threshold
                let newBadAppEvent = DeviceActivityEvent(
                    applications: badAppEvent.applications,
                    categories: badAppEvent.categories,
                    webDomains: badAppEvent.webDomains,
                    threshold: DateComponents(minute: (oldThreshold ?? 0) + (incrementThreshold ?? 0)),
                    includesPastActivity: true
                )
                
                // stop monitoring to reset monitoring
                DeviceActivityCenter().stopMonitoring()
                
                // create list of events
                let events = [
                    DeviceActivityEvent.Name("checkpoint"): checkpointEvent,
                    DeviceActivityEvent.Name("badAppMonitor"): newBadAppEvent,
                ]
                
                do {
                    try DeviceActivityCenter().startMonitoring(activity, during: schedule, events: events)
                } catch {
//                    Task {
//                        await sendNotification(title: "title", subtitle: "couldn't start monitoring")
//                    }
                }
                
                store.shield.applications = nil
                
                Task {
                    await sendNotification(title: "All good!", subtitle: "You can start using your \"unproductive\" apps now.")
                }
            }
        }
            
        else if event == DeviceActivityEvent.Name("badAppMonitor") {
            let events = DeviceActivityCenter().events(for: activity)
            
            if let badApps = events[DeviceActivityEvent.Name("badAppMonitor")]?.applications {
                store.shield.applications = badApps
            } else {
                Task {
                    await sendNotification(title: "Couldn't get bad apps", subtitle: "sorry")
                }
            }
            
//            Task {
//                await sendNotification(title:"Oh no!", subtitle: "Use your \"productive\" apps to get more time.")
//            }
        }
        
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
