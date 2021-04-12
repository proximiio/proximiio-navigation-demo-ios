//
//  PreviewCellLink.swift
//  Demo
//
//  Created by dev on 2/19/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SwiftyJSON
import SnapKit
import UIKit

class PreviewCellLink: UITableViewCell {
    static let identifier = "previewCellLink"
        
    public lazy var buttonLink: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = Theme.yellow.value
        button.setTitleColor(Theme.blueDarker.value, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    func populate(link: JSON?) {
        buttonLink.setTitle(link?["title"][Locale.current.languageCode ?? "en"].stringValue, for: .normal)
        buttonLink.onTap {
            guard let link = URL(string: link?["url"].stringValue ?? "" ) else { return }
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(buttonLink)
        buttonLink.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(44)
            $0.left.right.equalToSuperview().inset(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
