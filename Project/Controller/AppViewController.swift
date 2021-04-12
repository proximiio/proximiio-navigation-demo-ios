//
//  AppViewController.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import UIKit

class AppViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // add delegate
        self.delegate = self
    }
}

// MARK: - Delegate
extension AppViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // check if we are root view controller (aka 1 one vc)
        guard navigationController.viewControllers.count == 1 else { return }
    }
}
