//
//  NavigationView.swift
// Full
//
//  Created by dev on 11/5/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import ProximiioMapbox
import Proximiio
import Closures

protocol NavigationViewDelegate: class {
    func didTapStopNavigation()
}

class NavigationView: UIView {

    // MARK: - Public
    public var updateRouteDataPackage: PIORouteUpdateDataPackage? {
        didSet {
            DispatchQueue.main.async {
                // pass route info to child view
                self.viewHeading.updateRouteDataPackage = self.updateRouteDataPackage
                // self.viewNext.updateRouteDataPackage = self.updateRouteDataPackage

                // if we have no next node, hide the block and remove from view
                // self.viewNext.isHidden = (self.updateRouteDataPackage?.3?.nextStepDirection == nil)
            }
        }
    }
    public weak var delegate: NavigationViewDelegate?
    var hazard: ProximiioGeoJSON? {
        didSet {
            DispatchQueue.main.async {
                if let hazard = self.hazard {
                    self.viewHazard.hazard = hazard
                    self.viewHazard.snp.updateConstraints {
                        $0.height.equalTo(44)
                    }
                    self.perform(#selector(self.hideHazard), with: nil, afterDelay: 2)
                } else {
                    self.viewHazard.snp.updateConstraints {
                        $0.height.equalTo(0)
                    }
                }
            }
        }
    }
    var segment: ProximiioGeoJSON? {
        didSet {
            DispatchQueue.main.async {
                if let segment = self.segment {
                    self.viewLocation.segment = segment
                    self.viewLocation.snp.updateConstraints {
                        $0.height.equalTo(44)
                    }
                    self.perform(#selector(self.hideLocation), with: nil, afterDelay: 2)
                } else {
                    self.viewLocation.snp.updateConstraints {
                        $0.height.equalTo(0)
                    }
                }
            }
        }
    }

    // MARK: - Private variable
    public let viewHeading = HeadingView()
    // let viewNext = NextActionView()
    let viewHazard = HazardView()
    let viewLocation = LocationView()
    lazy var buttonClose: UIButtonWiderTap = {
        let button = UIButtonWiderTap(type: .custom)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = Theme.red.value
        button.setImage(UIImage(named: "modal-x"), for: .normal)
        return button
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func resetStatus() {
        // force reset components
        self.segment = nil
        self.hazard = nil
    }

    // MARK: - Setup UI
    private func setupUI() {

        resetStatus()

        // force dark background
        backgroundColor = .clear

        // add heading
        addSubview(viewHeading)
        viewHeading.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(120)
            $0.bottom.equalToSuperview().inset(8)
        }
        viewHeading.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonClose)
        buttonClose.onTap {
            self.delegate?.didTapStopNavigation()
        }
        buttonClose.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(44)
            $0.bottom.equalTo(viewHeading.snp.top).inset(12)
            $0.right.equalToSuperview().inset(16)
        }

        // add hazard
        addSubview(viewHazard)
        viewHazard.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(0)
            $0.bottom.equalTo(viewHeading.snp.top)

        }
        viewHazard.translatesAutoresizingMaskIntoConstraints = false

        // add locatio
        addSubview(viewLocation)
        viewLocation.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(0)
            $0.bottom.equalTo(viewHazard.snp.top)

        }
        viewLocation.translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: Helpers
extension NavigationView {
    @objc private func hideLocation() {
        self.viewLocation.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }

    @objc private func hideHazard() {
        self.viewHazard.snp.updateConstraints {
            $0.height.equalTo(0)
        }
    }
}
