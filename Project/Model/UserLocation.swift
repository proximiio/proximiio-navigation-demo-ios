//
//  UserLocation.swift
// Full
//
//  Created by dev on 11/25/19.
//  Copyright © 2019 dev. All rights reserved.
//

import CoreLocation
import Foundation
import Proximiio

class UserLocation {
    static let shared = UserLocation()

    var coordinate: CLLocationCoordinate2D?
    var floor: Int?
    var routeFrom: ProximiioGeoJSON?
}
