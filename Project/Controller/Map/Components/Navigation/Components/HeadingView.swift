//
//  HeadingView.swift
// Full
//
//  Created by dev on 11/5/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import ProximiioMapbox

class HeadingView: UIView {

    // MARK: - Public
    public var updateRouteDataPackage: PIORouteUpdateDataPackage? {
        didSet {
            DispatchQueue.main.async {
                // populate text and image
                if let heading = self.updateRouteDataPackage?.3?.stepHeading {
                    // self.labelNavigation.text = heading.text

                    let radians: CGFloat = CGFloat(heading.rotation * (.pi / 180))
                    self.imageNavigation.transform = CGAffineTransform(rotationAngle: radians)

                }
            }
        }
    }

    // MARK: - Private variable
    private let stack = UIStackView()
    private let imageNavigation = UIImageView()
    public let labelNavigation = UILabel()
    private var overrideWarning: Double = 0

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
        backgroundColor = Theme.white.value
        layer.cornerRadius = 20
        clipsToBounds = true

        // add stack horizontal
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        stack.translatesAutoresizingMaskIntoConstraints = false

        // add image of next action
        imageNavigation.tintColor = Theme.text(.dark).value
        imageNavigation.contentMode = .scaleAspectFit
        stack.addArrangedSubview(imageNavigation)
        imageNavigation.snp.makeConstraints {
            $0.width.equalTo(33)
        }
        imageNavigation.translatesAutoresizingMaskIntoConstraints = false
        imageNavigation.image = UIImage(named: "navigation-straight")

        // add then text
        stack.addArrangedSubview(labelNavigation)
        labelNavigation.translatesAutoresizingMaskIntoConstraints = false

        // give style to labels and autoscale
        labelNavigation.font = .preferredFont(forTextStyle: .title3)
        labelNavigation.minimumScaleFactor = 0.3
        labelNavigation.adjustsFontSizeToFitWidth = true
        labelNavigation.numberOfLines = 0
        labelNavigation.textColor = Theme.text(.dark).value
        labelNavigation.textAlignment = .left
    }
}
