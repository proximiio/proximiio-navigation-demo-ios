//
//  ProximiioGeofence+Extension.swift
//  Demo
//
//  Created by dev on 3/11/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Foundation
import Proximiio

extension ProximiioGeofence {
    public func getPolygonAsFeature() -> ProximiioGeoJSON? {
        if self.polygon.isEmpty { return nil }
        let feature = ProximiioGeoJSON(dictionary: [
                                        "type": "Polygon",
                                        "properties": ["dummy": ""],
                                        "geometry": ["type": "Polygon", "coordinates": self.polygon ?? []]])
        return feature
    }
}
