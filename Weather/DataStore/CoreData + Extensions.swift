//
//  CoreData + Extensions.swift
//  Weather
//
//  Created by Sapgv on 25/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import CoreLocation

extension Location {
    
    func fill(_ location: CLLocation) {
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
    
}
