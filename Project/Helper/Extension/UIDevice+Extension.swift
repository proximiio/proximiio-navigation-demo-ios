//
//  UIDevice+Extension.swift
//  ManagementApp
//
//  Created by dev on 8/7/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import UIKit

extension UIDevice {
    static var isSimulator: Bool = {
        var isSimulator = false
        #if targetEnvironment(simulator)
        isSimulator = true
        #endif
        return isSimulator
    }()
}
