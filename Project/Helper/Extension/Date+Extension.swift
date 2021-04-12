//
//  Date+Extension.swift
// Full
//
//  Created by dev on 11/26/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    static var todayDayOfWeek: Int {
        return (Date().dayNumberOfWeek() ?? 1) - 1
    }
}
