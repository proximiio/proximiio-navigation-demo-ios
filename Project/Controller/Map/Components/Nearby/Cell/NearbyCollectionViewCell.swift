//
//  NearbyCollectionViewCell.swift
//  Full
//
//  Created by dev on 10/6/20.
//  Copyright © 2020 dev. All rights reserved.
//

import UIKit
import SnapKit
import ProximiioMapLibre
import Proximiio
import Kingfisher

struct NearBy {
    let itemName: String
    let itemIcon: String
    let itemAmenityId: String?
}

class NearByCollectionViewCell: UICollectionViewCell {
    static let reuseId = "NearByCell"
    
    // MARK: - Private attributes
    private lazy var imageIcon: UIImageView = {
        let temp = UIImageView()
        temp.contentMode = .scaleAspectFit
        temp.clipsToBounds = true
        return temp
    }()
    
    private lazy var labelTitle: UILabel = {
        let temp = UILabel()
        temp.font = .preferredFont(forTextStyle: .body)
        temp.textAlignment = .center
        temp.numberOfLines = 1
        temp.textColor = Theme.text(.dark).value
        return temp
    }()
    
    public var nearby: NearBy?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setup(_ item: NearBy) {
        if let identifier = item.itemAmenityId {
            self.backgroundColor = Theme.amenity(identifier).value
        }
        nearby = item
        imageIcon.image = UIImage(named: item.itemIcon)
        imageIcon.tintColor = Theme.white.value
        labelTitle.text = item.itemName
        labelTitle.textColor = Theme.white.value
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(self.imageIcon)
        self.addSubview(self.labelTitle)
        
        self.layer.cornerRadius = 20.0
        self.clipsToBounds = true
        
        self.imageIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(13)
            $0.left.equalToSuperview().inset(17)
            $0.width.equalTo(22).priority(999)
            $0.height.equalTo(18).priority(999)
        }
        self.imageIcon.translatesAutoresizingMaskIntoConstraints = false
        
        self.labelTitle.snp.makeConstraints {
            $0.centerY.equalTo(imageIcon.snp.centerY)
            $0.left.equalTo(imageIcon.snp.right).offset(8)
            $0.right.equalToSuperview().inset(17)
        }
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
