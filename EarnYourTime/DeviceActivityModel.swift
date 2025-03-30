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
        @AppStorage(StorageKey.isMonitoring.rawValue) var isMonitoring: Bool = true
        
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
        isMonitoring = true
        print("Started monitoring at \(Calendar.current.component(.minute, from: Date()))")
    }

    // Stop monitoring device activity.
    func stopMonitoring() {
        @AppStorage(StorageKey.isMonitoring.rawValue) var isMonitoring: Bool = true
        
        let store = ManagedSettingsStore()
        store.shield.applications = nil
        store.shield.webDomains = nil
        
        self.deviceActivityCenter.stopMonitoring()
        isMonitoring = false
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
}
