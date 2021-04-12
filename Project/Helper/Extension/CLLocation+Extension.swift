//
//  CLLocation+Extension.swift
//  ManagementApp
//
//  Created by dev on 10/13/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import MapKit

// MARK: - Conversion
extension CLLocation {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return self.coordinate
    }
}

// MARK: - Array Conversion
extension Array where Element == CLLocation {
    func toCLLocationCoordinate2DArray() -> [CLLocationCoordinate2D] {
        var items: [CLLocationCoordinate2D] = []
        self.forEach({ item in
            items.append(CLLocationCoordinate2D(
                latitude: item.coordinate.latitude,
                longitude: item.coordinate.longitude)
            )
        })
        return items
    }

    func toJSONArrayOfAnchors() -> [[String: Double]] {
    var items: [[String: Double]] = []
        self.forEach { item in
            items.append(["lat": item.coordinate.latitude, "lng": item.coordinate.longitude])
        }
        return items
    }
}
