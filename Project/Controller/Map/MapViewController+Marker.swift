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
import UIKit

// if you want by any reason edit the annotation
class PIOAnnotationWithData: PIOAnnotation {
    var id: Int = 0
    var data: Int = 0
}

extension MapViewController {
    func addCustomMarkers() {
        let annotation = PIOAnnotationWithData()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 60.1671950369849, longitude: 24.921695923476054)
        // replace with the image you want
        annotation.image = UIImage(named: "destination")!
        // extra data added via override the `PIOAnnotation`
        annotation.id = 0
        annotation.data = 1
        annotation.title = "A test annotation at level 0"
        // remember to set the level to have this dynamically visible according current shown level
        annotation.level = 0
        annotation.onTap = { current in
            print("TAPPED")
        }

        let annotation2 = PIOAnnotationWithData()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 60.16746993048443, longitude: 24.922311676612107)
        annotation2.image = UIImage(named: "destination")!
        annotation2.id = 1
        annotation2.data = 2
        annotation2.title = "A second annotation at level 0"
        annotation2.level = 1
        annotation2.onTap = { current in
            guard let casted = current as? PIOAnnotationWithData else { return }
            print("TAPPED \(casted.id)")
        }

        let annotation3 = PIOAnnotationWithData()
        annotation3.image = UIImage(named: "destination")!
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 60.16714117139544, longitude: 24.92290485238969)
        annotation3.id = 2
        annotation3.data = 3
        annotation3.title = "A third annotation at level 0"
        annotation3.level = 0
        annotation3.onTap = { current in
            guard let casted = current as? PIOAnnotationWithData else { return }
            print("TAPPED \(casted.id) \(casted.data)")
        }

        mapView?.addAnnotations([annotation, annotation2, annotation3])
    }
}
