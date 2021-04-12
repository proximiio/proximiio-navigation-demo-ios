//
//  SearchDataSource.swift
//  Full
//
//  Created by dev on 12/22/20.
//  Copyright © 2020 dev. All rights reserved.
//

import Proximiio
import UIKit

class SearchDataSource: NSObject, UITableViewDataSource {

    public var list: [ProximiioGeoJSON]
    public var filter: String?

    init(_ list: [ProximiioGeoJSON] = []) {
        self.list = list
    }

    public func setList(_ list: [ProximiioGeoJSON], filter: String?) {
        self.list = list
        self.filter = filter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return list.count
        }
        return list.isEmpty ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchCellNoResult.identifier, for: indexPath) as? SearchCellNoResult {
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell {
                let feature = list[indexPath.row]
                cell.populate(feature, filter: filter)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
