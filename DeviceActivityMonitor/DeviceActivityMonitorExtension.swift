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


func sendNotification(title: String, body: String, waitDuration: Double = 1.0, repeats: Bool = false) async {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = UNNotificationSound.default
    content.interruptionLevel = .critical // set notification severity level
    content.badge = 0 // manually set badge number for app

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
        
        let events = DeviceActivityCenter().events(for: activity)
        
        if activity == DeviceActivityName("checkpoint"), event == DeviceActivityEvent.Name("checkpoint") {
            /// When the checkpoint event reaches its threshold, increase the bad app monitor's threshold.
            if let badAppSchedule = DeviceActivityCenter().schedule(for: DeviceActivityName("badAppMonitor")),
               let checkpointEvent = events[event],
               let badAppEvent = DeviceActivityCenter().events(for: DeviceActivityName("badAppMonitor"))[DeviceActivityEvent.Name("badAppMonitor")] {

                let oldThreshold = badAppEvent.threshold.minute ?? 0
                let incrementThreshold = checkpointEvent.threshold.minute ?? 0
                
                let newBadAppEvent = DeviceActivityEvent(
                    applications: badAppEvent.applications,
                    categories: badAppEvent.categories,
                    webDomains: badAppEvent.webDomains,
                    threshold: DateComponents(minute: oldThreshold + incrementThreshold),
                    includesPastActivity: true
                )
                
                // set checkpoint schedule to new time to start monitoring for a new checkpoint segment
                // without this, once the user hits their checkpoint (ie. 15 min), they will continously get notifications after
                let currentTime = Date()
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentTime)

                let checkpointSchedule = DeviceActivitySchedule(
                    intervalStart: dateComponents,
                    intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                    repeats: true
                )

                DeviceActivityCenter().stopMonitoring([DeviceActivityName("badAppMonitor")])
                DeviceActivityCenter().stopMonitoring([DeviceActivityName("checkpoint")])

                do {
                    try DeviceActivityCenter().startMonitoring(DeviceActivityName("badAppMonitor"), during: badAppSchedule, events: [DeviceActivityEvent.Name("badAppMonitor"): newBadAppEvent])
                    try DeviceActivityCenter().startMonitoring(DeviceActivityName("checkpoint"), during: checkpointSchedule, events: [DeviceActivityEvent.Name("checkpoint"): checkpointEvent])
                } catch {
                    print("Error restarting bad app monitoring: \(error)")
                }
                store.shield.applications = nil
                Task {
                    await sendNotification(title: "All good!", body: "You can start using your \"unproductive\" apps now.")
                }
            }
        }
        
        else if activity == DeviceActivityName("badAppMonitor"), event == DeviceActivityEvent.Name("badAppMonitor") {
            /// When the bad app monitor reaches its threshold, restrict bad apps.
            if let badApps = events[DeviceActivityEvent.Name("badAppMonitor")]?.applications {
                store.shield.applications = badApps
            } else {
                Task {
                    await sendNotification(title: "Couldn't get bad apps", body: "Sorry, something went wrong.")
                }
            }
        }
    }

    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle warning before the event reaches its threshold.
    }
}
