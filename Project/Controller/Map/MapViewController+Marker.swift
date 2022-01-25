//
//  MapViewController+Marker.swift
//  Demo
//
//  Created by Matteo Crippa on 24/01/22.
//  Copyright © 2022 dev. All rights reserved.
//

import Foundation
import ProximiioMapLibre
import CoreLocation

extension MapViewController {
    func addCustomMarkers() {
        let annotation = PIOAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 60.1671950369849, longitude: 24.921695923476054)
        annotation.image = UIImage.add
        annotation.title = "A test annotation at level 0"
        annotation.level = 0

        let annotation2 = PIOAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 60.16746993048443, longitude: 24.922311676612107)
        annotation2.image = UIImage.remove
        annotation2.title = "A second annotation at level 0"
        annotation2.level = 1

        let annotation3 = PIOAnnotation()
        annotation3.image = UIImage.actions
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 60.16714117139544, longitude: 24.92290485238969)
        annotation3.title = "A third annotation at level 0"
        annotation3.level = 0

        mapView?.addAnnotations([annotation, annotation2, annotation3])
    }
}
