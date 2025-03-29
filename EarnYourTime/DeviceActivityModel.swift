//
//  DeviceActivityModel.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/23/25.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import SwiftUI
import BackgroundTasks


// Extension for defining event names.
extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let checkpoint = Self("checkpoint")
    static let badAppMonitor = Self("badAppMonitor")
}

@Observable
class DeviceActivityModel {
    @ObservationIgnored @AppStorage(StorageKey.vacationMode.rawValue) var vacationMode: Bool = false
    @ObservationIgnored @AppStorage(StorageKey.vacationModeEndDate.rawValue) var vacationModeEndDate: Double = 0
    private var deviceActivityCenter: DeviceActivityCenter
    
    init() {
        self.deviceActivityCenter = DeviceActivityCenter()
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
        
        print("Bad selections: \(badSelections.applications.count) apps, \(badSelections.webDomains.count) web domains")
        print("Good selections: \(goodSelections.applications.count) apps, \(goodSelections.webDomains.count) web domains")
        print("Checkpoint time: \(formatDuration(seconds: checkpointTime)) minutes, Bad app time: \(formatDuration(seconds: badAppTime)) minutes")
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .checkpoint: DeviceActivityEvent(
                applications: goodSelections.applicationTokens,
                categories: goodSelections.categoryTokens,
                webDomains: goodSelections.webDomainTokens,
                threshold: DateComponents(minute: checkpointTime / 60),
                includesPastActivity: true
            ),
            .badAppMonitor: DeviceActivityEvent(
                applications: badSelections.applicationTokens,
                categories: badSelections.categoryTokens,
                webDomains: badSelections.webDomainTokens,
                threshold: DateComponents(minute: 0),
                includesPastActivity: true
            ),
        ]
        
        let schedule: DeviceActivitySchedule = DeviceActivitySchedule(
            // change here
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
        
        try self.deviceActivityCenter.startMonitoring(.daily, during: schedule, events: events)
        print("Started monitoring at \(Calendar.current.component(.minute, from: Date()))")
    }

    // Stop monitoring device activity.
    func stopMonitoring() {
        let store = ManagedSettingsStore()
        store.shield.applications = nil
        store.shield.webDomains = nil
        
        self.deviceActivityCenter.stopMonitoring()
        
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
    
    func checkVacationModeStatus() {
        let currentTime = Date().timeIntervalSince1970
        if vacationMode, currentTime >= vacationModeEndDate {
            stopVacationMode()
        }
    }

    func scheduleBackgroundTask() {
        let request = BGAppRefreshTaskRequest(identifier: "dan424gg.EarnYourTime.resumeMonitoring")

        request.earliestBeginDate = Date(timeIntervalSince1970: vacationModeEndDate) // Schedule when Vacation Mode ends
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Background task scheduled for \(vacationModeEndDate)")
        } catch {
            print("Could not schedule background task: \(error)")
        }
    }

    func startVacationMode(_ duration: Double) {
        let endDate = Date().addingTimeInterval(duration).timeIntervalSince1970
        vacationModeEndDate = endDate
        self.stopMonitoring()
        scheduleVacationEndNotification()
        self.scheduleBackgroundTask()
    }

    func stopVacationMode() {
        vacationModeEndDate = 0
        vacationMode = false
        
        do {
            try self.startMonitoring()
        } catch {}
    }

    func cancelVacationMode() {
        vacationModeEndDate = 0
        vacationMode = false
        
        cancelScheduledVacationNotification()
        cancelBackgroundTask()
        
        do {
            try self.startMonitoring()
        } catch {}
    }

    func cancelScheduledVacationNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["VacationModeEnd"])
        print("Canceled Vacation Mode notification")
    }

    func cancelBackgroundTask() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "dan424gg.EarnYourTime.resumeMonitoring")
        print("Canceled Vacation Mode background task")
    }

}
