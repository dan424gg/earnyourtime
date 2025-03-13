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
    @AppStorage(StorageKey.colorScheme.rawValue) private var colorScheme: String = "system"

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(DeviceActivityModel())
                .onAppear {
                    // Ensure to apply the appearance mode when the view appears
                    updateAppearanceMode()
                }
                .onChange(of: colorScheme) {
                    // Apply changes when the user selects a new appearance mode
                    updateAppearanceMode()
                }
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
