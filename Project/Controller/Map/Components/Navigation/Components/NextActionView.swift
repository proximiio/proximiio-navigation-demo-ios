//
//  NextActionView.swift
// Full
//
//  Created by dev on 11/5/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import ProximiioMapbox

class NextActionView: UIView {

    // MARK: - Public
    public var updateRouteDataPackage: PIORouteUpdateDataPackage? {
        didSet {
            DispatchQueue.main.async {
                // check and populate direction according
                if let direction = self.updateRouteDataPackage?.3?.stepDirection {

                    let distance = self.updateRouteDataPackage?.3?.stepDistance ?? 0
                    let dist = Settings.shared.routeDistanceUnits == .steps ? Utils.pathDistanceInSteps(distance: distance) : Int(distance)

                    // check if display distance in meters
                    if Settings.shared.routeDistanceUnits == .meters {
                        self.labelNavigation.text = "distance_meter_left".localized(dist)
                    } else {
                        self.labelNavigation.text = "distance_step_left".localized(dist)
                    }

                    self.imageNavigation.image = direction.image
                }
            }
        }
    }

    // MARK: - Private variable
    private let stack = UIStackView()
    private let imageStep = UIImageView()
    private let imageNavigation = UIImageView()
    private let labelNavigation = UILabel()

    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {

        // set darker background
        backgroundColor = Theme.backgroundNavigationNext.value

        // add stack horizontal
        stack.axis = .horizontal
        stack.spacing = 8

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 8))
        }
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(imageStep)
        imageStep.snp.makeConstraints {
            $0.width.equalTo(32)
            $0.height.equalTo(32)
        }
        imageStep.contentMode = .scaleAspectFit
        imageStep.image = UIImage(named: "poi-step")
        imageStep.translatesAutoresizingMaskIntoConstraints = false

        // add text first
        stack.addArrangedSubview(labelNavigation)
        labelNavigation.translatesAutoresizingMaskIntoConstraints = false

        // give style to labels and autoscale
        labelNavigation.font = .preferredFont(forTextStyle: .body)
        labelNavigation.minimumScaleFactor = 0.5
        labelNavigation.adjustsFontSizeToFitWidth = true
        labelNavigation.text = "navigation_next_action_then".localized()
        labelNavigation.textColor = .white
        labelNavigation.textAlignment = .left
        labelNavigation.numberOfLines = 1

        // and the the image of next action
        imageNavigation.tintColor = .white
        imageNavigation.contentMode = .scaleAspectFit
        stack.addArrangedSubview(imageNavigation)
        imageNavigation.snp.makeConstraints {
            $0.width.equalTo(32)
        }
        imageNavigation.translatesAutoresizingMaskIntoConstraints = false

        // add spacer
        stack.addArrangedSubview(UIView())
    }
}
