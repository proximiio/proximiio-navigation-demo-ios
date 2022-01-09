//
//  DemoFilter.swift
//  Demo
//
//  Created by dev on 2/17/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Foundation
import Proximiio
import ProximiioMapLibre

@objc class DemoFilter: NSObject, PIOFilter {
    
    var userLocation: CLLocationCoordinate2D?
    
    @objc func filterTag() -> String {
        "search"
    }
    
    @objc func inputNames() -> [String] {
        return ["title", "amenityCategoryId"]
    }
    
    @objc func filterItem(feature: ProximiioGeoJSON, input: [String]) -> Bool {
        
        let name = input[optional: 0]
        let amenity = input[optional: 1]
        
        let keys = ((feature.properties["metadata"] as? [String: Any])?["keywords"] as? [String] ?? []).compactMap { key -> String? in
            key.lowercased()
        }
        
        let hasName = (
            name == nil
                || name!.isEmpty
                || feature.getTitle().lowercased().contains(name!.lowercased())
                || keys.contains(where: {
                    $0.range(of: name!, options: .caseInsensitive) != nil
                })
        )
        
        let hasCategory = (
            amenity == nil
                || amenity!.isEmpty
                || feature.amenity == amenity
        )
        
        let hasPosition = (
            userLocation == nil
                || feature.coordinate == nil
                || (userLocation!.distance(feature.coordinate!) <= 800.0) // filtering items within 800mts from the position
        )
        
        return (
            hasName
                && hasCategory
                && hasPosition
        )
    }
}
