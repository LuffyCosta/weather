//
//  CLLocation+Placemark.swift
//  weatherApp
//
//  Created by Danilo Costa on 17/09/2021.
//

import Foundation
import CoreLocation

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
