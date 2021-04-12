//
//  AppDelegate+Routing.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

// MARK: - App UI Routing
extension AppDelegate {

    // route to the homepage (menu + map)
    func showApp(controller: UIViewController? = nil) {
        DispatchQueue.main.async {
            self.appController = AppViewController(rootViewController: MapViewController())
            let controller = controller ?? self.appController
            self.window?.rootViewController = controller
        }
    }

    // route to the splash page for loading purposes
    func showLoading() {
        let viewcontroller = SplashViewController()
        viewcontroller.view.backgroundColor = .white
        window?.rootViewController = viewcontroller
    }

    // force restart the app
    func restartApp() {
        window?.rootViewController = nil
        showLoading()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            self?.showApp()
        }
    }
}
