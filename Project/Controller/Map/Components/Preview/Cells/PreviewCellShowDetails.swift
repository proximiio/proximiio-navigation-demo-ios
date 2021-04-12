//
//  PreviewCellShowDetails.swift
//  Demo
//
//  Created by dev on 2/19/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SnapKit
import UIKit

class PreviewCellShowDetail: UITableViewCell {
    static let identifier = "previewCellShowDetail"
        
    public lazy var buttonShoMoreDetail: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "floor-down"), for: .normal)
        button.setTitle("show_more_detail".localized(), for: .normal)
        button.setTitleColor(Theme.blueDarker.value, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        button.centerTextAndImage(spacing: 10)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        contentView.addSubview(buttonShoMoreDetail)
        buttonShoMoreDetail.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(44)
            $0.left.right.equalToSuperview().inset(23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
