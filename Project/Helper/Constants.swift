//
//  Constants.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import CoreLocation
import UIKit

enum Url: String {
    case privacyPolicy = "https://proximi.io/privacy-policy"
    case terms = "https://proximi.io/terms-and-conditions"
}

// MARK: - UI Size handler
enum Size {
    case navigationHeight
    case searchHeight
    case nearbyHeight
    case floorDropdownHeight
    case floorHeight
}

extension Size {
    var value: CGFloat {
        switch self {
        case .floorDropdownHeight:
            return 200.0
        case .navigationHeight:
            return 264.0
        case .floorHeight:
            return 44.0
        case .searchHeight:
            return 44.0
        case .nearbyHeight:
            return 240.0
        }
    }
}

enum Key: String {
    case proximiioBufferSize = "k_tm_app_buffer_size"
    case bufferDefault = "Medium"
    case simulateWalk = "k_tm_simulate_walk"
}

// MARK: - Values
let stepLength = 0.65 // meters
let walkingSpeed = 1.4 // meters per second

// MARK: - App token
var appToken: String {
    return Bundle.main.object(forInfoDictionaryKey: "ProximiioToken") as? String ?? ""
}

var appApiVersion: String {
    return Bundle.main.object(forInfoDictionaryKey: "ProximiioApiVersion") as? String ?? "v5"
}
