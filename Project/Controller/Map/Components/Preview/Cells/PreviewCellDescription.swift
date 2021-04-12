//
//  PreviewCellDescription.swift
//  Demo
//
//  Created by dev on 2/19/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SnapKit
import UIKit

class PreviewCellDescription: UITableViewCell {
    static let identifier = "previewCellDescription"
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setStyle()
    }
    
    func populate(descr: String) {

        // force set style
        setStyle()

        // then populate content
        textLabel?.text = descr
        textLabel?.font = .preferredFont(forTextStyle: .footnote)
    }
    
    private func setStyle() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(22)
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel?.textColor = Theme.text(.dark).value
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
