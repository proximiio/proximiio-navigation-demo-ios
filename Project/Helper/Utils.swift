//
//  Utils.swift
// Full
//
//  Created by dev on 11/5/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

class Utils {
    // MARK: - Converter

    /// return number of steps
    static func pathDistanceInSteps(distance: Double) -> Int {
        return Int(distance/stepLength)
    }

    /// return the time remaining to complete the distance
    static func pathRemainingInSeconds(distance: Double) -> Int {
        return Int(distance/walkingSpeed)
    }

    /// return the time remaining to complete the distance
    static func pathRemainingInMinutes(distance: Double) -> Int {
        return Int((distance/walkingSpeed)/60)
    }
}
