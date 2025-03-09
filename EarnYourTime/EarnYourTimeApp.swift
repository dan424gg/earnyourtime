//
//  EarnYourTimeApp.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import SwiftData

@main
struct EarnYourTimeApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(DeviceActivityModel())
        }
    }
}
