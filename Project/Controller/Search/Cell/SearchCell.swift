//
//  SearchCell.swift
//  Demo
//
//  Created by dev on 2/15/21.
//  Copyright © 2021 dev. All rights reserved.
//

import Kingfisher
import Proximiio
import ProximiioMapLibre
import SnapKit
import UIKit

class SearchCell: UITableViewCell {
    
    static let identifier = "CellResultIdentifier"
    var feature: ProximiioGeoJSON?
    
    private lazy var labelName: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = Theme.text(.dark).value
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var labelFloor: UILabel = {
       let label = UILabel()
        label.textColor = Theme.text(.dark).value
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private lazy var imagePoi: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(imagePoi)
        imagePoi.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
            $0.width.equalTo(120)
            $0.height.equalTo(70)
        }
        
        contentView.addSubview(labelName)
        contentView.addSubview(labelFloor)
        labelName.snp.makeConstraints {
            $0.top.right.equalToSuperview().inset(16)
            $0.left.equalTo(imagePoi.snp.right).offset(8)
        }
        labelFloor.snp.makeConstraints {
            $0.top.equalTo(labelName.snp.bottom).offset(8)
            $0.bottom.right.equalToSuperview().inset(16)
            $0.left.equalTo(imagePoi.snp.right).offset(8)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(_ feature: ProximiioGeoJSON, filter: String? = nil) {
        self.feature = feature
        
        var prepend = ""
        
        if let filter = filter {
            
            let keys = ((feature.properties["metadata"] as? [String: Any])?["keywords"] as? [String] ?? [])
            
            let subItem = keys.first(where: {
                $0.range(of: filter, options: .caseInsensitive) != nil
            }) ?? ""
            
            if !subItem.isEmpty {
                prepend = subItem + "\n"
            }
        }
        
        imagePoi.image = getCategoryIcon()
        if let image = feature.images.first, let url = URL(string: image) {
            imagePoi.kf.setImage(with: url)
        }
        labelName.text = prepend + feature.getTitle()
        labelFloor.text = feature.floorReadable
    }
}

// MARK: - Category icon
extension SearchCell {
    fileprivate func getCategoryIcon() -> UIImage? {
        if let amenityIcon = PIODatabase.sharedInstance().amenities().first( where: { amenity -> Bool in
           amenity.identifier == feature?.amenity
        }) {
            let temp = amenityIcon.icon.components(separatedBy: "base64,")

            guard
                let data = temp[optional: 1],
                let imageData = Data(base64Encoded: data, options: Data.Base64DecodingOptions.ignoreUnknownCharacters),
                let image = UIImage(data: imageData)
                else {
                    return nil
            }
            return image
        }
        return nil
    }
}
