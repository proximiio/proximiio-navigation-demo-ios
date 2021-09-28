//
//  AppDelegate.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import ProximiioMapbox
import ProximiioProcessor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appController: UIViewController?

    // proximiio processors
    let simulationProcessor = ProximiioSimulationProcessor()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Proximiio setup
        setupProximiio()

        // load all libs
        loadAll()

        // setup the window for the app
        self.window = UIWindow(frame: UIScreen.main.bounds)

        // show loading screen
        showLoading()

        self.window?.makeKeyAndVisible()

        return true
    }
}
