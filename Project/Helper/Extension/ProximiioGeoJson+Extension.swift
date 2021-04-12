//
//  ProximiioGeoJson+Extension.swift
// Full
//
//  Created by dev on 11/26/19.
//  Copyright © 2019 dev. All rights reserved.
//

import ProximiioMapbox
import Proximiio

extension ProximiioGeoJSON {
    public var floorReadable: String {
        var patchedLevel = self.level
        if patchedLevel >= 0 {
            patchedLevel += 1
        }
        return "floor".localized(patchedLevel)
    }
}
