//
//  PreviewCellTakeMe.swift
//  Demo
//
//  Created by dev on 2/15/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SnapKit
import UIKit

class PreviewCellTakeMe: UITableViewCell {
    static let identifier = "previewCellTakeMe"
        
    public lazy var buttonTakeMeThere: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.backgroundColor = Theme.green.value
        button.setImage(UIImage(named: "modal-arrow"), for: .normal)
        button.setTitle("take_me_there".localized(), for: .normal)
        button.setTitleColor(Theme.blueDarker.value, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(buttonTakeMeThere)
        buttonTakeMeThere.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(44)
            $0.left.right.equalToSuperview().inset(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
