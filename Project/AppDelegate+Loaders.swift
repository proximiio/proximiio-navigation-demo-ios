//
//  AppDelegate+Loaders.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import IQKeyboardManagerSwift
import ProximiioMapbox
import UserNotifications

// MARK: - Loaders
extension AppDelegate {
    // takes care of loading all extra libs, customisation in one place
    func loadAll() {

        loadAnalytics()
        
        // setup UI
        loadUI()

        // load keyboard
        loadKeyboardHandler()

        // notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
        }
    }
}

// MARK: - AppCenter
extension AppDelegate {
    func loadAnalytics() {
        // TODO: add here your analytics
    }
}

// MARK: - UI
extension AppDelegate {
    func loadUI() {
        self.window?.tintColor = Theme.background(.dark).value
    }
}

// MARK: - UI
extension AppDelegate {

    // load keyboard handler
    fileprivate func loadKeyboardHandler() {
        // setup automated keyboard handler
        IQKeyboardManager.shared.enable = true
        // set tint
        IQKeyboardManager.shared.placeholderButtonColor = Theme.background(.dark).value
        IQKeyboardManager.shared.placeholderColor = Theme.background(.dark).value
        IQKeyboardManager.shared.toolbarTintColor = Theme.background(.dark).value
        IQKeyboardManager.shared.toolbarBarTintColor = Theme.background(.light).value
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
