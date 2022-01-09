//
//  PIORouteOptions+Extension.swift
// Full
//
//  Created by dev on 11/25/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import ProximiioMapLibre

extension PIOWayfindingOptions {
    static public var optionsConfiguration: PIOWayfindingOptions {
        return PIOWayfindingOptions(
            avoidElevators: Settings.shared.avoidElevator,
            avoidBarriers: Settings.shared.avoidBarriers,
            avoidEscalators: Settings.shared.avoidEscalator,
            avoidNarrowPaths: true,
            avoidRamps: Settings.shared.avoidRamps,
            avoidRevolvingDoors: Settings.shared.avoidRevolvingDoors,
            avoidStaircases: Settings.shared.avoidStairs,
            avoidTicketGates: Settings.shared.avoidTicketGates,
            pathFixDistance: 1.0
        )
    }
}
