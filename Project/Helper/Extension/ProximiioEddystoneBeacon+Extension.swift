//
//  ProximiioEddystoneBeacon+Extension.swift
//  ManagementApp
//
//  Created by dev on 9/16/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import ProximiioMapLibre
import Proximiio

extension ProximiioEddystoneBeacon {
    func isEqual(_ eddystone: ProximiioEddystoneBeacon) -> Bool {
        return eddystone.namespace == self.namespace && eddystone.instanceID == self.instanceID
    }
}

extension Array where Element == ProximiioEddystoneBeacon {
    mutating func add(_ eddystone: ProximiioEddystoneBeacon, replace: Bool = false) {
        // if it's already listed, do nothing
        if self.contains(where: { item -> Bool in
            return item.isEqual(eddystone)
        }) {
            if replace {
                remove(eddystone)
            } else {
                return
            }
        }

        // otherwise add it
        self.append(eddystone)
    }

    mutating func remove(_ eddystone: ProximiioEddystoneBeacon) {
        // check if in array and get index
        if let position = self.firstIndex(where: { item -> Bool in
            return item.isEqual(eddystone)
        }) {
            // and remove it
            self.remove(at: position)
        }
    }
}
