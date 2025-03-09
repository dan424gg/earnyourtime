//
//  DeviceActivityModel.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import SwiftUI


extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let checkpoint = Self("checkpoint")
    static let goodAppMonitor = Self("goodAppMonitor")
    static let badAppMonitor = Self("badAppMonitor")
}


@Observable
class DeviceActivityModel {
    @ObservationIgnored @AppStorage("badAppTime") var badAppTime: Int = 0
    @ObservationIgnored @AppStorage("checkpointTime") var checkpointTime: Int = 0

    var goodSelections: FamilyActivitySelection
    var badSelections: FamilyActivitySelection
    var center: DeviceActivityCenter
    var events: [DeviceActivityEvent.Name: DeviceActivityEvent]
    var schedule: DeviceActivitySchedule
    

    init() {
        self.goodSelections = FamilyActivitySelection(includeEntireCategory: true)
        self.badSelections = FamilyActivitySelection(includeEntireCategory: true)
        self.center = DeviceActivityCenter()
        self.schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
            repeats: true
        )
        self.events = [:]
    }
        
    /**
     Start monitoring for device activity.
     */
    func startMonitoring() throws {
        print("bad \(self.badSelections.applications.count) applications")
        print("bad \(self.badSelections.webDomains.count) web domains")
        
        print("good \(self.goodSelections.applications.count) applications")
        print("good \(self.goodSelections.webDomains.count) web domains")
        
        print("\(checkpointTime) minute checkpoint time")
        print("\(badAppTime) minute bad app time")
        
//        self.checkpointTime = checkpointTime
//        self.badAppTime = badAppTime
        
        self.events = [
            .checkpoint: DeviceActivityEvent(
                applications: self.goodSelections.applicationTokens,
                categories: self.goodSelections.categoryTokens,
                webDomains: self.goodSelections.webDomainTokens,
                threshold: DateComponents(minute: checkpointTime),
                includesPastActivity: false
            ),
            .badAppMonitor: DeviceActivityEvent(
                applications: self.badSelections.applicationTokens,
                categories: self.badSelections.categoryTokens,
                webDomains: self.badSelections.webDomainTokens,
                threshold: DateComponents(minute: badAppTime),
                includesPastActivity: false
            ),
//            .goodAppMonitor: DeviceActivityEvent(
//                applications: self.goodSelections.applicationTokens,
//                categories: self.goodSelections.categoryTokens,
//                webDomains: self.goodSelections.webDomainTokens,
//                threshold: DateComponents(minute: goodAppTime)
//            )
        ]
        
        try self.center.startMonitoring(.daily, during: self.schedule, events: self.events)
        
        print("started monitoring (\(Calendar.current.component(.minute, from: Date())))")
    }
    
    
    /**
     Stop monitoring device activity.
     */
    func stopMonitoring() {
        let store = ManagedSettingsStore()
        store.shield.applications = nil
        store.shield.webDomains = nil
        
        self.center.stopMonitoring()
        
        print("stopped monitoring")
    }
    
}
