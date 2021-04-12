//
//  UIImage+Extension.swift
// Full
//
//  Created by Matej Drzik on 18/12/2019.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func roundedImage(_ radius: CGFloat) -> UIImage? {
        var imageView = UIImageView()
        if self.size.width > self.size.height {
            imageView.frame =  CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
            imageView.image = self
            imageView.contentMode = .scaleAspectFit
        } else { imageView = UIImageView(image: self) }
        var layer: CALayer = CALayer()

        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return roundedImage
    }
}

public extension UIImage {

    /**
    Returns image with size 1x1px of certain color.
    */
    class func imageWithColor(color: UIColor, size: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }

//    /**
//    Returns current image colored to certain color.
//    */
//    @available(*, deprecated, message:"Use similar build-in XCAssetCatalog functionality.")
//    public func imageWithColor(color: UIColor) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
//
//        let context = UIGraphicsGetCurrentContext()
//        CGContextTranslateCTM(context, 0, self.size.height)
//        CGContextScaleCTM(context, 1.0, -1.0)
//
//
//        CGContextSetBlendMode(context, .Normal)
//
//        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
//        CGContextClipToMask(context, rect, self.CGImage)
//        color.setFill()
//        CGContextFillRect(context, rect)
//
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage;
//    }
}
