//
//  MapOverlayFooter.swift
//  Demo
//
//  Created by dev on 2/11/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import SnapKit
import Closures
import ProximiioMapLibre
import Proximiio
import Combine

class MapOverlayFooter: UIView {
    private var subscriptions = Set<AnyCancellable>()
    public var action = PassthroughSubject<Action, Never>()

    public var updateRouteDataPackage: PIORouteUpdateDataPackage? {
        didSet {
            guard
                let update = self.updateRouteDataPackage
                else {
                    /// hide all navigation, but show search search
                    self.hide(navigation: true, search: false, nearby: true)
                    return
            }

            /// if type is cancel, hide stuff in less than 1 sec
            switch update.0 {
            case .canceled, .routeNotfound, .finished:
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
                    self?.hide(navigation: true, search: false, nearby: false)
                }
            case .calculating, .recalculating:
                /// in this scenario not show the summary is not yet needed
                self.hide(navigation: false, search: true, nearby: true)
            default:
                /// otherwise hide search and show the rest
                self.hide(navigation: false, search: true, nearby: true)
            }

            /// pass route data to child view to allow UI updates smoothly
            self.navigationView.updateRouteDataPackage = self.updateRouteDataPackage
        }
    }
    public var hazard: ProximiioGeoJSON? {
        didSet {
            self.navigationView.hazard = self.hazard
        }
    }
    public var segment: ProximiioGeoJSON? {
        didSet {
            self.navigationView.segment = self.segment
        }
    }

    // MARK: - Private variable

    // nearby box
    public lazy var nearbyView: NearbyView = {
        let nearby = NearbyView()
        nearby.action.sink { (what) in
            switch what {
            case .filter(let nearby):
                self.action.send(.nearby(nearby))
            }
        }.store(in: &subscriptions)
        return nearby
    }()

    // navigation box
    public var navigationView = NavigationView()

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    public func updateSettings() {
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        /// extra cleanup to avoid issue with delegates
        subviews.forEach { $0.removeFromSuperview() }

        /// on base start show only search
        navigationView.isHidden = true
        navigationView.resetStatus()
        nearbyView.isHidden = false

        /// force cleanup
        subviews.forEach { $0.removeFromSuperview() }

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .bottom
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        verticalStack.addArrangedSubview(UIView())

        /// add spacer
        verticalStack.addArrangedSubview(UIView.spacer(of: 10))

        /// nearby view
        verticalStack.addArrangedSubview(nearbyView)
        nearbyView.snp.makeConstraints {
            $0.height.equalTo(NearbyView.heightCollapsed)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        nearbyView.translatesAutoresizingMaskIntoConstraints = false

        /// navigation view
        verticalStack.addArrangedSubview(navigationView)
        navigationView.delegate = self
        navigationView.snp.makeConstraints {
            $0.height.equalTo(Size.navigationHeight.value)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        navigationView.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Navigation View Delegate
extension MapOverlayFooter: NavigationViewDelegate {
    func didTapStopNavigation() {
        self.action.send(.routeStop)
    }
}

// MARK: - Allow touches to pass
extension MapOverlayFooter {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            return self.subviews.contains(view) ? nil : view
        }
        return nil
    }
}

// MARK: - Visibility handler
extension MapOverlayFooter {
    /// manage visibility of navigation and summary
    @objc func hide(navigation: Bool = true, search: Bool = true, nearby: Bool) {
        DispatchQueue.main.async {
            self.navigationView.isHidden = navigation
            if navigation {
                self.navigationView.resetStatus()
            }
            self.nearbyView.isHidden = nearby
        }
    }
}

// MARK: - Action
extension MapOverlayFooter {
    enum Action {
        case routeStop
        case nearby(NearBy)
    }
}
