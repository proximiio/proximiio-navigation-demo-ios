//
//  ProximiioIBeacon+Extension.swift
//  ManagementApp
//
//  Created by dev on 8/21/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import ProximiioMapLibre
import Proximiio

extension ProximiioIBeacon {
    func isEqual(_ beacon: ProximiioIBeacon) -> Bool {
        return self.uuid == beacon.uuid && self.minor == beacon.minor && self.major == beacon.major
    }
}

extension Array where Element == ProximiioIBeacon {
    mutating func add(_ beacon: ProximiioIBeacon, replace: Bool = false) {
        // if it's already listed, do nothing
        if self.contains(where: { item -> Bool in
            return item.isEqual(beacon)
        }) {
            if replace {
                remove(beacon)
            } else {
                return
            }
        }

        // otherwise add it
        self.append(beacon)
    }

    mutating func remove(_ beacon: ProximiioIBeacon) {
        // check if in array and get index
        if let position = self.firstIndex(where: { item -> Bool in
            return item.isEqual(beacon)
        }) {
            // and remove it
            self.remove(at: position)
        }
    }
}
