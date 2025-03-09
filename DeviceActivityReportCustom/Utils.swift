//
//  Utils.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//

import Foundation

func formatDuration(seconds: Int) -> String {
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}
