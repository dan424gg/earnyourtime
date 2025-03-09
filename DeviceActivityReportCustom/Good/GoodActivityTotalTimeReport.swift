//
//  GoodActivityTotalTimeReport.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//


import DeviceActivity
import ManagedSettings
import SwiftUI
import UserNotifications



extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    static let goodActivity = Self("GoodActivity")
}


struct GoodActivityTotalTimeReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    let context: DeviceActivityReport.Context = .goodActivity
    
    // Define the custom configuration and the resulting view for this report.
    let content: (String) -> GoodActivityTotalTimeView
    
    func makeConfiguration(representing data: DeviceActivityResults<DeviceActivityData>) async -> String {
        // Reformat the data into a configuration that can be used to create
        // the report's view.

        // Returning total activity for the device
//        let totalActivityDuration = await data.flatMap { $0.activitySegments }.reduce(0) { total, segment in
//            total + segment.totalActivityDuration
//        }
        
        var totalDuration: Int = 0
        
        for await d in data {
            for await a in d.activitySegments{
                for await c in a.categories {
                    for await ap in c.applications {
                        totalDuration += Int(ap.totalActivityDuration)
                    }
                }
            }
        }

        
        return String(totalDuration)
    }
}
