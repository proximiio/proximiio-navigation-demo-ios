//
//  String+Extension.swift
//  ManagementApp
//
//  Created by dev on 8/12/19.
//  Copyright © 2019 proximiio. All rights reserved.
//

import Foundation
import MapKit

let kfirstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let kserverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let kemailRegex = kfirstpart + "@" + kserverpart + "[A-Za-z]{2,8}"
let kemailPredicate = NSPredicate(format: "SELF MATCHES %@", kemailRegex)

// MARK: - Email validation
extension String {
    func isEmail() -> Bool {
        return kemailPredicate.evaluate(with: self)
    }
}

// MARK: - Address geocoding
extension String {
    func coordinateFromAddress(geocoder: CLGeocoder, completion: @escaping (_ location: CLLocationCoordinate2D?) -> Void) {
        guard !self.isEmpty else {
            completion(nil)
            return
        }
        geocoder.geocodeAddressString(self) { placemarks, _ in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location?.coordinate else { return }
            completion(location)
        }
    }
}

// MARK: - Localization
extension String {
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), locale: nil, arguments: arguments)
    }
}
