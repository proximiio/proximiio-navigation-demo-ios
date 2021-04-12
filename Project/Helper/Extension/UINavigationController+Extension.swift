//
//  UINavigationController+Extension.swift
//  ManagementApp
//
//  Created by dev on 8/23/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import UIKit

// MARK: UI
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

// MARK: Back handler
public protocol BackButtonHandler: class {
    func shouldPopOnBackButton() -> Bool
}

extension UINavigationController: UINavigationBarDelegate {
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {

        if viewControllers.count < (navigationBar.items?.count) ?? 0 {
            return true
        }

        var shouldPop = true
        let controller = self.topViewController

        if let controller = controller as? BackButtonHandler {
            shouldPop = controller.shouldPopOnBackButton()
        }

        if shouldPop {
            DispatchQueue.main.async {[weak self] in
                _ = self?.popViewController(animated: true)
            }
        } else {
            for subView in navigationBar.subviews {
                if 0 < subView.alpha && subView.alpha < 1 {
                    UIView.animate(withDuration: 0.25, animations: {
                        subView.alpha = 1
                    })
                }
            }
        }

        return false
    }
}
