//
//  MapViewController.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Closures
import Combine
import Mapbox
import PopupDialog
import Proximiio
import ProximiioMapbox
import SnapKit
import TapticEngine
import UserNotifications
import UIKit

class MapViewController: BaseViewController {
    
    internal var mapView: MGLMapView?
    internal var mapUIOverlayHeader = MapOverlayHeader()
    internal var mapUIOverlayFooter = MapOverlayFooter()
    internal var currentRoute: PIORoute?
    internal var isOutOfGeofence = true
    
    internal var subscriptions = Set<AnyCancellable>()
    
    // preview view
    internal lazy var previewView: PreviewRoute = {
        let preview = PreviewRoute()
        preview.action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .expand:
                    preview.snp.updateConstraints {
                        $0.height.equalTo(340)
                    }
                case .parking(let feature, let parking):
                    self?.showPreview(feature: feature, parking: parking)
                case .cancel:
                    self?.previewCancel()
                case .levelUpdate(let level):
                    ProximiioMapbox.shared.setLevel(level: level)
                case .start(let feature, let route):
                    self?.previewStart(feature: feature, route: route)
                }
            }.store(in: &subscriptions)
        return preview
    }()
    internal var isPreview = true
    
    private lazy var settings = UIBarButtonItem.init(image: UIImage.init(named: "settings")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), style: .plain, handler: { [weak self] in
        // force cancel route
        ProximiioMapbox.shared.routeCancel(silent: false)
        
        // dismiss preview accessory view (if needed)
        self?.previewCancel()
        
        // create settings view controller
        let svc = SettingsViewController()
        self?.present(svc, animated: true, completion: nil)
    })
    
    private var inputs: [ProximiioInput] {
        if let inputs = Proximiio.sharedInstance()?.inputs() {
            return inputs
        }
        return []
    }
    
    internal var currentUserPosition: CLLocationCoordinate2D? {
        didSet {
            // store here to easy share accross the app
            if let floor = Proximiio.sharedInstance()?.currentFloor()?.level?.intValue {
                UserLocation.shared.floor = floor
            }
            
            UserLocation.shared.coordinate = currentUserPosition
        }
    }
    
    func setFloor(floor: ProximiioFloor) {
        DispatchQueue.global(qos: .background).async {
            
            self.mapUIOverlayHeader.setFloorDropdownTitle(floor: floor)
            
            // update map UI
            DispatchQueue.main.async {
                ProximiioMapbox.shared.setLevel(level: floor.level.intValue)
            }
            self.mapUIOverlayHeader.populateFloorList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapUIOverlayFooter.updateSettings()
        if Settings.shared.accessibilityUISide == .right {
            navigationItem.setRightBarButton(settings, animated: true)
        } else {
            navigationItem.setLeftBarButton(settings, animated: true)
        }
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        checkPerms()
        
        ProximiioMapbox.shared.say(text: "Welcome to Proximi.io Demo")
        
        // manage behaviour
        // force follow the path of current route
        ProximiioMapbox.shared.shakyHandsMode = Settings.shared.navigationType == .path
        
        // manage navigator
        let metadataKeys = [Settings.shared.accessibilityDisabilities+1]
        ProximiioMapbox.shared.navigation?.ttsEnable(enable: Settings.shared.guidanceEnabled)
        ProximiioMapbox.shared.navigation?.ttsHeadingCorrection(enabled: true)
        ProximiioMapbox.shared.navigation?.ttsDecisionAlert(enabled: Settings.shared.voiceGuidanceSpeakDecision, metadataKeys: metadataKeys)
        ProximiioMapbox.shared.navigation?.ttsHazardAlert(enabled: Settings.shared.voiceGuidanceSpeakWarning, metadataKeys: metadataKeys)
        ProximiioMapbox.shared.navigation?.ttsLandmarkAlert(enabled: Settings.shared.voiceGuidanceSpeakLandmark, metadataKeys: metadataKeys)
        ProximiioMapbox.shared.navigation?.ttsSegmentAlert(
            enterEnabled: Settings.shared.voiceGuidanceSpeakSegment,
            exitEnabled: Settings.shared.voiceGuidanceSpeakSegment,
            metadataKeys: metadataKeys)
        //
        ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(enabled: Settings.shared.voiceGuidanceConfirmTrip)
        switch Settings.shared.voiceGuidanceConfirmTripDistance {
        case 0:
            ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(distance: 10.0)
        case 1:
            ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(distance: 15.0)
        case 2:
            ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(distance: 20.0)
        case 3:
            ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(distance: 25.0)
        default:
            ProximiioMapbox.shared.navigation?.ttsReassuranceInstruction(distance: 15.0)
        }
        
        if Settings.shared.routeDistanceUnits == .steps {
            let converter = PIOUnitConversion(stageList: [
                PIOUnitConversion.UnitStage(unitName: "steps", unitConversionToMeters: 1.0 / stepLength, minValueInMeters: 0.0, decimals: 0)
            ])
            ProximiioMapbox.shared.navigation?.setUnitConversion(conversion: converter)
        } else {
            ProximiioMapbox.shared.navigation?.setUnitConversion(conversion: .Default )
        }
        
        // pass information about simulate walk
        ProximiioMapbox.shared.debugShowDevelopmentRoutes = false
        ProximiioMapbox.shared.enableSimulationWalk(enabled: UserDefaults.standard.bool(forKey: Key.simulateWalk.rawValue))
        
        // force disable idle
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDelegate.showCalibration()
        
        // set view title
        title = "map_title".localized()
        
        // setup map
        setupMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // restore normal idle screen
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    private func setupMap() {
        // setup map
        let mapToken = Proximiio.sharedInstance()?.token() ?? ""
        Proximiio.sharedInstance()?.delegate = self
        
        let config = ProximiioMapboxConfiguration(token: mapToken)
        config.showRasterFloorplans = false
        config.showGeoJSONFloorplans = true
        
        // prepare map
        mapView = MGLMapView(frame: view.frame)
        // set map delegate
        self.mapView?.delegate = self
        self.mapView?.logoViewPosition = .bottomLeft
        self.mapView?.logoViewMargins = CGPoint(x: 20, y: 20)
        self.mapView?.attributionButtonPosition = .bottomRight
        self.mapView?.setZoomLevel(16, animated: false)
        if let mapView = mapView {
            ProximiioMapbox.shared.setup(mapView: mapView, configuration: config)
            ProximiioMapbox.shared.patchGroundLevel = 1
            ProximiioMapbox.shared.initialize { result in
                if result == .success {
                    ProximiioMapbox.shared.mapNavigation = self
                    ProximiioMapbox.shared.mapInteraction = self
                }
            }
            
            prepareMapUI()
            
        }
    }
    
    private func prepareMapUI() {
        
        // add map
        guard let mapView = mapView else { return }
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // set view background
        view.backgroundColor = .clear
        
        view.addSubview(previewView)
        previewView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(0.0)
        }
        
        // add buttons and searchbar
        mapUIOverlayHeader.removeFromSuperview()
        view.addSubview(mapUIOverlayHeader)
        
        mapUIOverlayHeader.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(mapView.snp.top)
        }
        
        // add buttons and searchbar
        mapUIOverlayFooter.removeFromSuperview()
        view.addSubview(mapUIOverlayFooter)
        
        mapUIOverlayFooter.snp.makeConstraints {
            $0.height.equalTo(UIScreen.main.bounds.height)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(mapView.snp.bottom)
        }
        
        // setup receivers
        setupReceivers()
    }
    
    override func didReceiveMemoryWarning() {
        freeMemory()
    }
    
    deinit {
        freeMemory()
    }
    
    private func freeMemory() {
        // cleanup delegates
        self.mapView?.delegate = nil
        Proximiio.sharedInstance()?.delegate = nil
        
        self.mapUIOverlayFooter.removeFromSuperview()
        self.mapView?.removeFromSuperview()
        
        self.mapView = nil
        ProximiioMapbox.shared.resetMap()
    }
}

// MARK: - Permission
extension MapViewController {
    func showLocationPermissionDialog() {
        let alert = UIAlertController(
            title: "map_location_permission_title".localized(),
            message: "map_location_permission_message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "map_no".localized(), style: .destructive, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "map_yes".localized(), style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func showMissingBluetoothDialog() {
        let alert = UIAlertController(
            title: "map_location_bluetooth_title".localized(),
            message: "map_location_bluetooth_message".localized(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "map_no".localized(), style: .destructive, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "map_yes".localized(), style: .default, handler: { (_) in
            alert.dismiss(animated: true, completion: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkBluetooth() {
        if #available(iOS 13.0, *) {
            if CBCentralManager().authorization != .allowedAlways {
                showMissingBluetoothDialog()
            }
        } else {
            if CBPeripheralManager.authorizationStatus() != .authorized {
                showMissingBluetoothDialog()
            }
        }
    }
    
    func checkPerms() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showLocationPermissionDialog()
            default:
                break
            }
        } else {
            showLocationPermissionDialog()
        }
    }
    
}

// MARK: - Map center to user
extension MapViewController {
    @objc internal func centerAtUser(with zoom: Double = 18) {
        
        let isUserOutOfGeofence = userOutOfGeofence()
        
        // check is user is out of geofence
        let coordinate = UserLocation.shared.coordinate
        
        // mapbox is so stupid, that need to set to none to be later set to proper value
        if let coordinate = coordinate {
            
            DispatchQueue.main.async {
                // center user position
                if !isUserOutOfGeofence {
                    self.mapView?.setUserTrackingMode(.followWithHeading, animated: true, completionHandler: {
                        self.mapView?.setCenter(coordinate, zoomLevel: zoom, animated: true)
                    })
                } else {
                    ProximiioMapbox.shared.followingUser = false
                    self.mapView?.setCenter(coordinate, zoomLevel: 14, animated: true)
                }
            }
            
            guard
                let floor = UserLocation.shared.floor,
                let current = self.mapUIOverlayHeader.floors.first(where: { item -> Bool in item.level.intValue == floor })
            else { return }
            self.setFloor(floor: current)
        }
    }
}

// MARK: - Proximiio Delegate
extension MapViewController: ProximiioDelegate {
    
    func onProximiioReady() {}
    
    func proximiioFloorChanged(_ floor: ProximiioFloor!) {
        // atm better not use this
        setFloor(floor: floor)
    }
    
    func proximiioPositionUpdated(_ location: ProximiioLocation!) {
        currentUserPosition = location.coordinate
        userOutOfPlace()
    }
}

// MARK: - Subscribers
extension MapViewController {
    
    internal func userNavigationMode(forceOn: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            if !forceOn {
                ProximiioMapbox.shared.followingUser = !ProximiioMapbox.shared.followingUser
            } else {
                ProximiioMapbox.shared.followingUser = true
            }
            self?.mapUIOverlayHeader.trackingUser = ProximiioMapbox.shared.followingUser
            // force center to user position
            if ProximiioMapbox.shared.followingUser {
                self?.centerAtUser()
            }
        }
    }
    
    fileprivate func setupReceivers() {
        self.mapUIOverlayHeader
            .action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .center:
                    self?.centerAtUser()
                case .compass:
                    self?.userNavigationMode()
                case .select(let feature):
                    self?.showPreview(feature: feature)
                case .search(let filter, let nearby):
                    self?.showSearch(filter: filter, nearby: nearby)
                case .floor(let floor):
                    self?.setFloor(floor: floor)
                }
            }.store(in: &subscriptions)
        
        self.mapUIOverlayFooter
            .action
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .nearby(let nearby):
                    self?.showSearch(filter: nil, nearby: nearby)
                case .routeStop:
                    self?.hideAnnotations()
                    ProximiioMapbox.shared.routeCancel(silent: false)
                }
            }.store(in: &subscriptions)
        
    }
    
}

// MARK: - Helper
extension MapViewController {
    private func showSearch(filter: String?, nearby: NearBy?) {
        let searchViewController = SearchViewController()
        searchViewController.modalPresentationStyle = .fullScreen
        searchViewController
            .action
            .sink { [weak self] action in
                switch action {
                case .card(let feature):
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.showPreview(feature: feature)
                }
            }.store(in: &subscriptions)
        
        if let text = filter {
            searchViewController.viewModel.filter = text
        }
        
        if let category = nearby {
            searchViewController.viewModel.category = [category]
        }
        
        self.navigationController?.pushViewController(searchViewController, animated: true)
    }
}

// MARK: - Check
extension MapViewController {
    
    func userOutOfGeofence() -> Bool {
        
        return false
        
        // TODO: replace with geofence id
//        let geofenceBig = "GEOFENCE-ID"
//
//        isOutOfGeofence = true
//
//        if let coordinate = UserLocation.shared.coordinate {
//            Proximiio.sharedInstance()?.geofences().forEach {
//                if $0.uuid == geofenceBig, $0.circularRegion()?.contains(coordinate) ?? false {
//                    isOutOfGeofence = false
//                }
//            }
//        }
//
//        if isOutOfGeofence {
//
//            let alert = UIAlertController(
//                title: "map_out_geofence_title".localized(),
//                message: "map_out_geofence_message".localized(),
//                preferredStyle: .alert
//            )
//
//            alert.addAction(UIAlertAction(title: "map_out_geofence_close".localized(), style: .destructive, handler: { (_) in
//                alert.dismiss(animated: true, completion: nil)
//                self.mapView?.showsUserLocation = false
//            }))
//
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.mapView?.showsUserLocation = true
//            }
//        }
//
//        return isOutOfGeofence
    }
    
    func userOutOfPlace() {
        // TODO: replace with geofence id
        let geofencePlace = "GEOFENCE-ID"
        var isInside = false
        if let coordinate = UserLocation.shared.coordinate {
            if let geofence = Proximiio.sharedInstance()?.geofences()?.first(where: {
                $0.uuid == geofencePlace
            }) {
                if
                    geofence.isPolygon(),
                    let feature = geofence.getPolygonAsFeature(),
                    PIOTurf.inside(point: coordinate, poly: [feature.coordinates]) {
                        isInside = true
                }
            }
        }
//        if !isInside {
//            DispatchQueue.main.async { [weak self] in
//                self?.zoomOutAndBiggerDot()
//            }
//        }
    }
    
    private func zoomOutAndBiggerDot() {
        let userAnnotation = self.mapView?.value(forKey: "userLocationAnnotationView") as? UIView
        userAnnotation?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        self.centerAtUser(with: 16)
    }
}

// MARK: - Update map
extension MapViewController: MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        
        // set first map position center on dewa
        DispatchQueue.main.async {
            mapView.setUserTrackingMode(.followWithHeading, animated: true, completionHandler: nil)
        }
        
        self.perform(#selector(MapViewController.centerAtUser), with: nil, afterDelay: 1.8)
        
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    public func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if let current = annotation as? ParkAnnotation, current.isParking {
            
            let identifier = "parkAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MGLAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let imageView = UIImageView(image: current.image)
                annotationView!.frame = CGRect(x: 0, y: 0, width: current.image.size.width, height: current.image.size.height)
                annotationView?.addSubview(imageView)
                annotationView?.centerOffset = CGVector(dx: -current.image.size.width / 5.0, dy: -current.image.size.height / 5.0)
            }
            
            return annotationView
        }
        
        if let current = annotation as? PIOAnnotation {
            
            let identifier = "destinationAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MGLAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                let imageView = UIImageView(image: current.image)
                annotationView!.frame = CGRect(x: 0, y: 0, width: current.image.size.width, height: current.image.size.height)
                annotationView?.addSubview(imageView)
                annotationView?.centerOffset = CGVector(dx: 0, dy: -current.image.size.height / 2.0)
            }
            
            annotationView?.isHidden = current.isHidden
            
            return annotationView
        }
        
        return nil
    }
}
