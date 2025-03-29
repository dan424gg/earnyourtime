//
//  EarnYourTimeApp.swift
//  EarnYourTime
//
//  Created by Daniel Wells on 3/8/25.
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct EarnYourTimeApp: App {
    @AppStorage(StorageKey.colorScheme.rawValue) private var colorScheme: String = "system"
    
    private var deviceActivityModel = DeviceActivityModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(deviceActivityModel)
                .onAppear {
                    // Ensure to apply the appearance mode when the view appears
                    updateAppearanceMode()
                    
                    registerBackgroundTask()
                }
                .onChange(of: colorScheme) {
                    // Apply changes when the user selects a new appearance mode
                    updateAppearanceMode()
                }
        }
    }

    func handleBackgroundTask(task: BGTask) {
        deviceActivityModel.checkVacationModeStatus()
        task.setTaskCompleted(success: true)
    }

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "dan424gg.EarnYourTime.resumeMonitoring", using: nil) { task in
            handleBackgroundTask(task: task as! BGAppRefreshTask)
        }
    }
    
    private func updateAppearanceMode() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            if colorScheme == "system" {
                window?.overrideUserInterfaceStyle = .unspecified
            } else {
                let style: UIUserInterfaceStyle = colorScheme == "dark" ? .dark : .light
                window?.overrideUserInterfaceStyle = style
            }
        }
    }
}
