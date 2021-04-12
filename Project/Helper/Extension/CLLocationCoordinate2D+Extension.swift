//
//  File.swift
//  ManagementApp
//
//  Created by dev on 10/13/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import Proximiio
import MapKit

extension CLLocationCoordinate2D {
    
    func feature(level: Int) -> ProximiioGeoJSON? {
        let feature = ProximiioGeoJSON(dictionary:
                                        [
                                            "type": "Feature",
                                            "geometry": [ "type": "Point", "coordinates": [self.longitude, self.latitude]],
                                            "properties": [ "level": level]
                                        ]
        )
        return feature
    }
    
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }

    static func zero() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
extension Array where Element == CLLocationCoordinate2D {
    func toCLLocationArray() -> [CLLocation] {
        var items: [CLLocation] = []
        self.forEach({ item in
            items.append(CLLocation(latitude: item.latitude, longitude: item.longitude))
        })
        return items
    }
}
