//
//  MapViewController+Preview.swift
//  Full
//
//  Created by dev on 11/6/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import ProximiioMapbox
import Proximiio

// TODO: replace adding your parking identifier
let parkingIdentifier = "REPLACE-ME"

// MARK: - Preview handler
extension MapViewController {
    internal func showPreview(feature: ProximiioGeoJSON?, parking: Bool = false) {
            
        // calculate
        guard let feature = feature else {
            return
        }
        
        var waypoints: [PIOWaypoint] = []
        
        hideAnnotationPark()
        
        if parking, let coordinate = feature.coordinate {
                        
            let closestParking = PIODatabase.sharedInstance().features()
                .filter {
                    $0.amenity == parkingIdentifier
                }
                .sortedByDistance(from: coordinate).first
            
            let parkAnnotation = ParkAnnotation()
            parkAnnotation.level = 0

            if let parking = closestParking {
                if let parkCoords = closestParking?.coordinate {
                    parkAnnotation.coordinate = parkCoords
                }
                waypoints.append(SimpleWaypoint(feature: parking))
            }

            if let image = UIImage(named: "parking_highlight") {
                parkAnnotation.image = image
            }
            mapView?.addAnnotation(parkAnnotation)
        }
        
        let configuration = PIORouteConfiguration(
            start: nil,
            destination: feature,
            waypointList: waypoints,
            wayfindingOptions: PIOWayfindingOptions.optionsConfiguration
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.mapUIOverlayFooter.hide(navigation: true, search: true, nearby: true)

            self?.previewView.viewModel.feature = feature

            self?.view.layoutSubviews()

            ProximiioMapbox.shared.hidePreviewDestinationMarker()
            ProximiioMapbox.shared.showPreviewDestinationMarker(UIImage(named: "destination"), coordinate: feature.coordinate, level: feature.level)

            self?.isPreview = true
            
            ProximiioMapbox.shared.routeFindAndPreview(configuration: configuration) { route in
                self?.previewView.viewModel.route = route
                
                self?.previewView.snp.updateConstraints {
                    $0.height.equalTo(282)
                }
                self?.previewView.buttonClose.isHidden = false
            }
        }
    }

    internal func hidePreview() {
        isPreview = false

        previewView.snp.updateConstraints {
            $0.height.equalTo(0)
        }
        previewView.buttonClose.isHidden = true
        view.layoutSubviews()
        mapUIOverlayFooter.hide(navigation: true, search: false, nearby: false)
    }
    
    fileprivate func hideAnnotationPark() {
        self.mapView?.annotations?.forEach {
            if let annotation = $0 as? ParkAnnotation, annotation.isParking {
                DispatchQueue.main.async {
                    self.mapView?.removeAnnotation(annotation)
                }
            }
        }
    }
    
    func hideAnnotations() {
        DispatchQueue.main.async {
            ProximiioMapbox.shared.hidePreviewDestinationMarker()
            self.hideAnnotationPark()
        }
    }
}

// MARK: - Preview
extension MapViewController {
    internal func previewStart(feature: ProximiioGeoJSON?, route: PIORoute?) {
        previewView.reset()
        hidePreview()

        // generate route
        ProximiioMapbox.shared.mapNavigation = self
        ProximiioMapbox.shared.mapInteraction = self
        DispatchQueue.global(qos: .background).async {
            ProximiioMapbox.shared.routeStart(route)
        }
    }

    internal func previewCancel() {
        previewView.reset()
        hideAnnotations()
        hidePreview()
        ProximiioMapbox.shared.mapNavigation = self
        ProximiioMapbox.shared.mapInteraction = self
        ProximiioMapbox.shared.routeCancel(silent: true)
        mapUIOverlayFooter.hide(navigation: true, search: false, nearby: false)
    }
}
