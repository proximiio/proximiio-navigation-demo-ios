//
//  PreviewCellDetails.swift
//  Demo
//
//  Created by dev on 2/15/21.
//  Copyright © 2021 dev. All rights reserved.
//

import SnapKit
import UIKit

class PreviewCellStats: UITableViewCell {
    
    static let identifier = "previewCellStats"
    
    private lazy var labelName: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = Theme.blueDarker.value
     return label
    }()
    
    private lazy var labelDescription: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.textColor = Theme.black.value
     return label
    }()
    
    private lazy var labelDistance: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 1
        label.textColor = Theme.blueMid.value
        return label
    }()
    
    private lazy var iconDistance: UIImageView = {
        let image = UIImageView(image: UIImage(named: "modal-walking"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        isUserInteractionEnabled = true
        
        addSubview(labelName)
        labelName.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(23)
            $0.top.equalToSuperview().offset(12)
        }
        
        addSubview(labelDescription)
        labelDescription.snp.makeConstraints {
            $0.top.equalTo(labelName.snp.bottom)
            $0.left.right.equalToSuperview().inset(23)
        }
        
        addSubview(iconDistance)
        iconDistance.snp.makeConstraints {
            $0.top.equalTo(labelDescription.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(23)
            $0.width.equalTo(12)
        }
        
        addSubview(labelDistance)
        labelDistance.snp.makeConstraints {
            $0.centerY.equalTo(iconDistance.snp.centerY)
            $0.left.equalTo(iconDistance.snp.right).offset(8)
            $0.right.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Populate
extension PreviewCellStats {
    public func populate(name: String? = "", description: String? = "", distance: Double) {
        labelName.text = name
        labelDescription.text = description
        labelDistance.text = convert(distance)
    }
}

// MARK: - Helpers
extension PreviewCellStats {
    fileprivate func convert(_ distance: Double) -> String {

        // check what user prefer
        let dist = Settings.shared.routeDistanceUnits == .steps ? Utils.pathDistanceInSteps(distance: distance) : Int(distance)

        var final = ""

        let sec = Utils.pathRemainingInSeconds(distance: distance)
        final += sec > 60 ?  "time_minute".localized(sec/60) : "time_second".localized(sec)
        
        final += "  ("
        
        // check if display distance in meters
        if Settings.shared.routeDistanceUnits == .meters {
            final += "distance_meter".localized(dist)
        } else {
            let steps = Utils.pathDistanceInSteps(distance: distance)
            final += "distance_step".localized(steps)
        }
        final += ")"
        
        return final
    }
}
