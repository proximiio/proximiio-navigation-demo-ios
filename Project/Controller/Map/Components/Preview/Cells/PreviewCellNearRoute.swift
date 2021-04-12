//
//  PreviewCellNearRoute.swift
//  Demo
//
//  Created by dev on 2/15/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SnapKit
import UIKit

class PreviewCellNearRoute: UITableViewCell {
    static let identifier = "previewCellNearRoute"
            
    public lazy var buttonNearestParking: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = Theme.blueMid.value
        button.setImage(UIImage(named: "modal-parking"), for: .normal)
        button.setImage(UIImage(named: "modal-parking")?.withTintColor(Theme.blueMid.value), for: .selected)
        button.setTitle("nearest_parking".localized(), for: .normal)
        button.setTitle("nearest_parking_selected".localized(), for: .selected)
        button.setTitleColor(Theme.white.value, for: .normal)
        button.setTitleColor(Theme.blueMid.value, for: .selected)
        button.setBackground(Theme.blueMid.value, for: .normal)
        button.setBackground(Theme.white.value, for: .selected)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    public lazy var buttonShowRoute: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = Theme.gray.value
        button.setImage(UIImage(named: "modal-route"), for: .selected)
        button.setImage(UIImage(named: "modal-route"), for: .normal)
        button.setTitle("show_route".localized(), for: .normal)
        button.setTitle("show_route_selected".localized(), for: .selected)
        button.setTitleColor(Theme.blueDarker.value, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(buttonNearestParking)
        buttonNearestParking.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.left.equalToSuperview().inset(23)
            $0.height.equalTo(44)
        }
        
        contentView.addSubview(buttonShowRoute)
        buttonShowRoute.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(44)
            $0.left.equalTo(buttonNearestParking.snp.right).offset(8)
            $0.width.equalTo(buttonNearestParking.snp.width).dividedBy(2)
            $0.right.equalToSuperview().inset(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
