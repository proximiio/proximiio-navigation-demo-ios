//
//  SplashViewController.swift
// Full
//
//  Created by dev on 11/3/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.image = UIImage(named: "header-logo")
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(166.0)
            $0.height.equalTo(166.0)
        }

        view.addSubview(spinner)
        spinner.center = CGPoint(x: view.center.x, y: view.center.y + 80.0)
        spinner.color = Theme.blueDarker.value
        spinner.startAnimating()
    }
}
