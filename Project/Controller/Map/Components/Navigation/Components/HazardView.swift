//
//  HazardView.swift
// Full
//
//  Created by dev on 11/30/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import ProximiioMapLibre
import Proximiio

class HazardView: UIView {

    // MARK: - Public
    var hazard: ProximiioGeoJSON? {
        didSet {
            DispatchQueue.main.async {
                if let hazard = self.hazard {
                    self.labelTitle.text = "hazard".localized(hazard.getTitle())
                }
            }
        }
    }

    // MARK: - Private vars
    /// general horizontal stack
    private let labelTitle = UILabel()

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
        self.backgroundColor = Theme.backgroundNavigationHazard.value

        labelTitle.text = "Placeholder"
        labelTitle.textColor = .white
        labelTitle.textAlignment = .center

        addSubview(labelTitle)
        labelTitle.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(6)
        }
        labelTitle.translatesAutoresizingMaskIntoConstraints = false

        /// give style to labels and autoscale
        labelTitle.font = .preferredFont(forTextStyle: .title1)
        labelTitle.minimumScaleFactor = 0.5
        labelTitle.adjustsFontSizeToFitWidth = true
    }
}
