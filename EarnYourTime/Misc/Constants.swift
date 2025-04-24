//
//  Constants.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/12/25.
//

import Foundation


enum StorageKey: String {
    case fullName
    case vacationMode
    case checkpointTime
    case badAppTime
    case badFamilySelections
    case goodFamilySelections
    case colorScheme
    case seenIntroSequence
    case vacationModeEndDate
    case isMonitoring
}

enum SettingsDestination: Identifiable {
    case name
    case vacationMode
    case notifications
    case goodApps
    case badApps
    case checkpointTime
    case badAppTimeLimit
    case appearance
    
    var id: Self { self }
}

enum SettingsCategory: Identifiable {
    case personal
    case appExperience
    case appearance
    case other
    
    var id: Self { self }
}


