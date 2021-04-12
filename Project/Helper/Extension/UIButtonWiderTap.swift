//
//  UIButtonWiderTap.swift
//  Demo
//
//  Created by dev on 2/21/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit

class UIButtonWiderTap: UIButton {
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            return bounds.insetBy(dx: -20, dy: -20).contains(point)
        }
}
