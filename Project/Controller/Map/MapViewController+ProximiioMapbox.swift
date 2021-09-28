//
//  MapViewController+Proximiio.swift
//  Full
//
//  Created by dev on 10/6/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Foundation
import Proximiio
import ProximiioMapbox
import TapticEngine
import Combine

// MARK: - PDR helper
extension MapViewController {
    private func calculatePathPdr(route: PIORoute, level: Int? = UserLocation.shared.floor) -> [[CLLocation]] {
        let path = route
            .nodeList
            .filter { $0.level == UserLocation.shared.floor }
            .compactMap { node -> [CLLocation] in
                return node.lineStringCoordinates.toCLLocationArray()
            }
        return path
    }
}

// MARK: - ProximiioMapBox Delegate
extension MapViewController: ProximiioMapboxNavigation {

    func onRoute(route: PIORoute?) {
        // reset location and hazards
        self.mapUIOverlayFooter.hazard = nil
        self.mapUIOverlayFooter.segment = nil
        self.currentRoute = route

        // set pdr
        DispatchQueue.main.async { [weak self] in
            if  let route = self?.currentRoute,
                let app = UIApplication.shared.delegate as? AppDelegate,
                let path = self?.calculatePathPdr(route: route) {
                app.simulationProcessor.set(routes: path)
            }
        }

        // force center at user
        centerAtUser()
    }

    func routeEvent(eventType type: PIORouteUpdateType, text: String, additionalText: String?, data: PIORouteUpdateData?) {
        guard !isPreview else { return }

        DispatchQueue.main.async {
            let pendingStepForNode = Utils.pathDistanceInSteps(distance: data?.stepDistance ?? 0)
            if pendingStepForNode == 0 {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            }

            // pass update data to UI
            self.mapUIOverlayFooter.updateRouteDataPackage = (type, text, additionalText, data)

            if type == .canceled || type == .finished, let floor = Proximiio.sharedInstance()?.currentFloor() {
                self.setFloor(floor: floor)
                self.currentRoute = nil
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.simulationProcessor.set(routes: [])
                }
                self.hideAnnotations()
            }
        }
    }

    func onHazardEntered(_ hazard: ProximiioGeoJSON) {
        self.mapUIOverlayFooter.hazard = hazard
    }

    func onHazardExit(_ hazard: ProximiioGeoJSON) {
        if hazard.identifier == self.mapUIOverlayFooter.hazard?.identifier {
            self.mapUIOverlayFooter.hazard = nil
        }
    }

    func onSegmentEntered(_ segment: ProximiioGeoJSON) {
        self.mapUIOverlayFooter.segment = segment
    }

    func onDecisionEntered(_ decision: ProximiioGeoJSON) {}

    func onLandmarkEntered(_ landmarks: [PIOLandmark]) {}

    func onSegmentExit(_ segment: ProximiioGeoJSON) {
        if segment.identifier == self.mapUIOverlayFooter.segment?.identifier {
            self.mapUIOverlayFooter.segment = nil
        }
    }

    func onDecisionExit(_ decision: ProximiioGeoJSON) {}

    func onLandmarkExit(_ landmarks: [ProximiioGeoJSON]) {}

    func onPositionUpdate(_ position: CLLocationCoordinate2D) {}

    func onHeadingUpdate(_ heading: Double) {}

    func onTTS() {
        if Settings.shared.vibrationEnabled {
            TapticEngine.notification.feedback(.success)
        }
    }
    
    func onTTSDirection(text: String?) {
        DispatchQueue.main.async {
            self.mapUIOverlayFooter.navigationView.viewHeading.labelNavigation.text = text
        }
    }
}

extension MapViewController: ProximiioMapboxInteraction {
    func change(floor: Int) {
        self.changeFloor(floor)

        // set processor
        if  let route = currentRoute,
            let app = UIApplication.shared.delegate as? AppDelegate {
            app.simulationProcessor.set(routes: calculatePathPdr(route: route))
            self.currentRoute = route
        }
    }

    internal func changeFloor(_ floor: Int, force: Bool = false) {
        if floor == UserLocation.shared.floor && !force { return }

        mapUIOverlayHeader.currentFloor = floor
        UserLocation.shared.floor = floor

        if let currentFloor = self.mapUIOverlayHeader.floors.first(where: { item -> Bool in
            item.level.intValue == floor }) {
            setFloor(floor: currentFloor)
        }
    }

    func onRequestReRoute() {}

    func onFollowingUserUpdate(_ isFollowing: Bool) {
        DispatchQueue.main.async {
            self.mapUIOverlayHeader.trackingUser = isFollowing
        }
    }

    func onTap(feature: ProximiioGeoJSON?) {
        // avoid that if route is running we can tap on poi
        guard currentRoute == nil else { return }
        self.showPreview(feature: feature)
    }
}
