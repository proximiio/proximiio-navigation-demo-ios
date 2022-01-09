//
//  MapViewController+Preview.swift
//  Full
//
//  Created by dev on 11/6/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import ProximiioMapLibre
import Proximiio

// MARK: - Preview handler
extension MapViewController {
    internal func showPreview(feature: ProximiioGeoJSON?) {
            
        // calculate
        guard let feature = feature else {
            return
        }

        let configuration = PIORouteConfiguration(
            start: nil,
            destination: feature,
            waypointList: [],
            wayfindingOptions: PIOWayfindingOptions.optionsConfiguration
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.mapUIOverlayFooter.hide(navigation: true, search: true, nearby: true)

            self?.previewView.viewModel.feature = feature

            self?.view.layoutSubviews()

            ProximiioMapLibre.shared.hidePreviewDestinationMarker()
            ProximiioMapLibre.shared.showPreviewDestinationMarker(UIImage(named: "destination"), coordinate: feature.coordinate, level: feature.level)

            self?.isPreview = true
            
            ProximiioMapLibre.shared.routeFindAndPreview(configuration: configuration) { route in
                self?.previewView.viewModel.route = route
                
                self?.previewView.snp.updateConstraints {
                    $0.height.equalTo(242)
                }
                self?.previewView.buttonClose.isHidden = false
            }
        }
    }

    internal func hidePreview() {
        DispatchQueue.main.async { [weak self] in
            self?.isPreview = false

            self?.previewView.snp.updateConstraints {
                $0.height.equalTo(0)
            }
            self?.previewView.buttonClose.isHidden = true
            self?.view.layoutSubviews()
            self?.mapUIOverlayFooter.hide(navigation: true, search: false, nearby: false)
        }
    }
    
    func hideAnnotations() {
        DispatchQueue.main.async {
            ProximiioMapLibre.shared.hidePreviewDestinationMarker()
        }
    }
}

// MARK: - Preview
extension MapViewController {
    internal func previewStart(feature: ProximiioGeoJSON?, route: PIORoute?) {
        previewView.reset()
        hidePreview()

        // generate route
        ProximiioMapLibre.shared.mapNavigation = self
        ProximiioMapLibre.shared.mapInteraction = self
        DispatchQueue.global(qos: .background).async {
            ProximiioMapLibre.shared.routeStart(route)
        }
    }

    internal func previewCancel() {
        hidePreview()
        previewView.reset()

//        DispatchQueue.main.async { [weak self] in
//            self?.hidePreview()
//            // ProximiioMapLibre.shared.mapNavigation = self
//            // ProximiioMapLibre.shared.mapInteraction = self
//            // self?.mapUIOverlayFooter.hide(navigation: true, search: false, nearby: false)
//            self?.previewView.reset()
//        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.hideAnnotations()
            ProximiioMapLibre.shared.routeCancel(silent: true)
        }
    }
}
