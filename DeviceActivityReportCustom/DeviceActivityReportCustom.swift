//
//  DeviceActivityReportCustom.swift
//  DeviceActivityReportCustom
//
//  Created by Daniel Wells on 3/8/25.
//

import DeviceActivity
import SwiftUI

@main
struct DeviceActivityReportCustom: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        BadActivityTotalTimeReport { activityReport in
            BadActivityTotalTimeView(activityReport: activityReport)
        }
        
        GoodActivityTotalTimeReport { activityReport in
            GoodActivityTotalTimeView(activityReport: activityReport)
        }
    }
}
