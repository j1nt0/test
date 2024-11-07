//
//  AppTrackingManager.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//

import SwiftUI
import AppKit

@Observable
class AppTrackingManager {
    var currentApp: NSRunningApplication? = nil
    var multipeerManager = MultipeerManager()

    init() {
        NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didActivateApplicationNotification,
            object: nil,
            queue: .main) { [weak self] notification in
                guard let self = self else { return }
                if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication {
                    if self.currentApp != app {
                        self.currentApp = app
                        self.handleAppChanged(app: app)
                    }
                }
        }
    }

    func handleAppChanged(app: NSRunningApplication) {
        let appName = app.localizedName ?? "Unknown App"
        multipeerManager.sendAppInfo(appName: appName)
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
}
