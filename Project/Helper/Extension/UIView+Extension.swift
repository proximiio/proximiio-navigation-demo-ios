//
//  UIView+Extension.swift
//  ManagementApp
//
//  Created by dev on 10/7/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import UIKit

// MARK: - Gradient
extension UIView {
    func layerGradient(colors: [CGColor]) {
        self.layer.sublayers = self.layer.sublayers?.filter {!($0 is CAGradientLayer)}
        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint.zero
        layer.colors = colors
        self.layer.insertSublayer(layer, at: 0)
    }
}

// MARK: - Rounded corners
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - Generate spacer
extension UIView {
    static func spacer(of height: Double) -> UIView {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(height)
        }
        return view
    }
}
