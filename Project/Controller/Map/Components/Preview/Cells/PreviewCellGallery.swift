//
//  PreviewCellGallery.swift
//  Demo
//
//  Created by dev on 2/19/21.
//  Copyright © 2021 dev. All rights reserved.
//

import UIKit
import SnapKit
import DKCarouselView
import Closures

class PreviewCellGallery: UITableViewCell {
    static let identifier = "previewCellGallery"
    
    private var images = [String]()
    private let gallery = DKCarouselView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // set cell style
        setStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func populate(images: [String]) {
        /// store local instance
        self.images = images

        /// force set style
        setStyle()

        let items = images.map({ url -> DKCarouselItem in
            let item = DKCarouselURLItem()
            item.imageUrl = url
            item.contentMode = .scaleAspectFill
            return item
        })
        
        /// add items to gallery
        gallery.setItems(items)
        
        /// check if user taps image
        gallery.setDidSelect { (_, _) in
        }
    }

    private func setStyle() {
        /// custom UI
        backgroundColor = .clear
        
        contentView.addSubview(gallery)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gallery.indicatorIsVisible = true
        gallery.indicatorTintColor = .white
        gallery.isFinite = false
        gallery.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
}
