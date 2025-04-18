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
    static let checkpoint = Self("checkpoint")
    static let badAppMonitor = Self("badAppMonitor")
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
    enum MonitoringType {
        case checkpoint
        case badApps
        case all
    }

    func startMonitoring(type: MonitoringType = .all, includesPastActivity: Bool = false) throws {
        @AppStorage(StorageKey.badAppTime.rawValue) var badAppTime: Int = -1
        @AppStorage(StorageKey.checkpointTime.rawValue) var checkpointTime: Int = -1
        @AppStorage(StorageKey.goodFamilySelections.rawValue) var goodSelectionsStorage: Data = Data()
        @AppStorage(StorageKey.badFamilySelections.rawValue) var badSelectionsStorage: Data = Data()
        @AppStorage(StorageKey.isMonitoring.rawValue) var isMonitoring: Bool = true
        @AppStorage(StorageKey.recentUpdateTime.rawValue) var recentUpdateTime: Double = 0
        
        let goodSelections: FamilyActivitySelection = decode(FamilyActivitySelection.self, from: goodSelectionsStorage, defaultValue: FamilyActivitySelection())
        let badSelections: FamilyActivitySelection = decode(FamilyActivitySelection.self, from: badSelectionsStorage, defaultValue: FamilyActivitySelection())

        print("Bad selections: \(badSelections.applications.count) apps, \(badSelections.webDomains.count) web domains")
        print("Good selections: \(goodSelections.applications.count) apps, \(goodSelections.webDomains.count) web domains")
        print("Checkpoint time: \(formatDuration(seconds: checkpointTime)) minutes, Bad app time: \(formatDuration(seconds: badAppTime)) minutes")

        func startCheckpointMonitoring() throws {
            let checkpointSchedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                repeats: true
            )
            
            let checkpointEvent = DeviceActivityEvent(
                applications: goodSelections.applicationTokens,
                categories: goodSelections.categoryTokens,
                webDomains: goodSelections.webDomainTokens,
                threshold: DateComponents(minute: checkpointTime / 60),
                includesPastActivity: false
            )

            try self.deviceActivityCenter.startMonitoring(.checkpoint, during: checkpointSchedule, events: [.checkpoint: checkpointEvent])
            print("Started checkpoint monitoring with its own schedule")
        }

        func startBadAppMonitoring() throws {
            let badAppSchedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                repeats: true
            )

            let badAppEvent = DeviceActivityEvent(
                applications: badSelections.applicationTokens,
                categories: badSelections.categoryTokens,
                webDomains: badSelections.webDomainTokens,
                threshold: DateComponents(minute: 0),
                includesPastActivity: false
            )

            try self.deviceActivityCenter.startMonitoring(.badAppMonitor, during: badAppSchedule, events: [.badAppMonitor: badAppEvent])
            print("Started bad app monitoring with its own schedule")
        }

        switch type {
        case .checkpoint:
            try startCheckpointMonitoring()
        case .badApps:
            try startBadAppMonitoring()
        case .all:
            try startCheckpointMonitoring()
            try startBadAppMonitoring()
        }

        isMonitoring = true
        recentUpdateTime = Date().timeIntervalSince1970
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
