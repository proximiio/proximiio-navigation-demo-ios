//
//  AppDelegate+Calibration.swift
//  Full
//
//  Created by dev on 6/4/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit

extension AppDelegate {
    class func showCalibration() {

        let lastShowedKey = "calibration_last_showed"
        let lastShowed = UserDefaults.standard.double(forKey: lastShowedKey)
        let needsReshow = lastShowed - Date().timeIntervalSince1970 > (60*24*7)

        if lastShowed == 0.0 || needsReshow {
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastShowedKey)

            let size: CGFloat = 250.0
            let showAlert = UIAlertController(
                title: "calibration_title".localized(),
                message: "calibration_message".localized(),
                preferredStyle: .alert
            )
            let imageView = UIImageView(frame: CGRect(x: 0, y: 110, width: size, height: size))
            imageView.image = UIImage(named: "calibration")
            imageView.contentMode = .scaleAspectFit
            showAlert.view.addSubview(imageView)
            let height = NSLayoutConstraint(
                item: showAlert.view,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: size+160
            )
            let width = NSLayoutConstraint(
                item: showAlert.view,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                multiplier: 1,
                constant: size+20
            )
            showAlert.view.addConstraint(height)
            showAlert.view.addConstraint(width)
            showAlert.addAction(UIAlertAction(title: "calibration_dismiss".localized(), style: .default, handler: { _ in
            }))
            UIApplication.topViewController()?.present(showAlert, animated: true, completion: nil)
        }

    }
}
