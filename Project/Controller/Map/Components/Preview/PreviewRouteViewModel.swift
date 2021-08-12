//
//  PreviewRouteViewModel.swift
//  Full
//
//  Created by dev on 1/4/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Combine
import Foundation
import Proximiio
import ProximiioMapbox

public class PreviewRouteViewModel {
    @Published public var route: PIORoute?
    @Published public var feature: ProximiioGeoJSON?
    @Published public var showTrip: Bool = false
    @Published public var isFullView: Bool = false
    @Published public var instructions: [PIORouteNode] = []
}
