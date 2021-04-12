//
//  SearchCellNoResult.swift
//  Demo
//
//  Created by dev on 2/15/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit

class SearchCellNoResult: UITableViewCell {
    
    static let identifier = "CellNoResultIdentifier"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        textLabel?.text = "no_results".localized()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
