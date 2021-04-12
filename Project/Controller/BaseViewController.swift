//
//  BaseViewController.swift
//  ManagementApp
//
//  Created by dev on 8/7/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var notificationChangeApplication = NotificationCenter()

    // manage white status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // set navigation color
        styleNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Navigation
extension BaseViewController {

    private func styleNavigationBar() {
        navigationController?.navigationBar.barTintColor = Theme.white.value
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.tintColor = Theme.blueDarker.value

        let logo = UIImageView()
        logo.backgroundColor = Theme.white.value
        logo.image = UIImage(named: "header-logo")
        logo.contentMode = .scaleAspectFit
        navigationItem.titleView = logo
    }

}
