//
//  PreviewCellDirection.swift
// Full
//
//  Created by dev on 12/20/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import ProximiioMapLibre

class PreviewCellDirection: UITableViewCell {

    static let identifier = "previewCellDirection"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup(step: PIORouteNode) {
        textLabel?.text = step.text
        textLabel?.numberOfLines = 0
        textLabel?.textColor = Theme.text(.dark).value
        detailTextLabel?.textColor = Theme.text(.dark).value

        let dist = Settings.shared.routeDistanceUnits == .steps ? Utils.pathDistanceInSteps(distance: step.distanceFromLastNode) : Int(step.distanceFromLastNode)

        // check if display distance in meters
        if dist > 0 {
            if Settings.shared.routeDistanceUnits == .meters {
                self.detailTextLabel?.text = "distance_meter".localized(dist)
            } else {
                self.detailTextLabel?.text = "distance_step".localized(dist)
            }
        }

        imageView?.image = step.direction.image
        imageView?.tintColor = Theme.text(.dark).value

        // workaround for start
        if Utils.pathDistanceInSteps(distance: step.distanceFromLastNode) == 0, textLabel?.text?.isEmpty ?? false {
            textLabel?.text = "preview_my_location".localized()
        }
    }

}
