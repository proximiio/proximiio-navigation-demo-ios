//
//  PIOGuidanceDirection+Extension.swift
// Full
//
//  Created by dev on 11/7/19.
//  Copyright © 2019 dev. All rights reserved.
//

import ProximiioMapLibre

extension PIOGuidanceDirection {

    var imageName: String? {
        switch self {
        case .straight:
            return "navigation-straight"
        case .leftHard, .leftNormal, .leftSlight:
            return "navigation-left"
        case .rightHard, .rightNormal, .rightSlight:
            return "navigation-right"
        case .finish:
            return "icons8-flag-filled"
        case .start:
            return "poi-direction"
        case .turnAround:
            return "navigation-roundabout"

        case .upElevator,
             .upEscalator,
             .upStairs:
            return "icons8-stairs-24"

        case .downElevator,
             .downEscalator,
             .downStairs:
            return "icons8-stairs-24"
        default:
            return ""
        }
    }

    var image: UIImage? {
        guard let name = imageName else { return nil }
        return UIImage(named: name)
    }

    var imagePath: URL? {
        guard let name = imageName else { return nil }
        if let bundle = Bundle.main.url(forResource: name, withExtension: "png") {
            return bundle
        }
        return nil
    }

    var imageNotitication: UNNotificationAttachment? {
        guard
            let name = imageName,
            let url = imagePath
            else { return nil}

        if let attachment = try? UNNotificationAttachment(identifier: name,
                                                          url: url,
                                                          options: nil) {
            return attachment
        }
        return nil
    }
}
