//
//  Collection+Extension.swift
//  ManagementApp
//
//  Created by dev on 12/24/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import Foundation

extension Collection {
    subscript(optional item: Index) -> Iterator.Element? {
        return self.indices.contains(item) ? self[item] : nil
    }
}
