//
//  CoreData + Extensions.swift
//  Weather
//
//  Created by Sapgv on 25/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import CoreLocation

extension CoreDataLocation {
    
    static func findAll() -> [CoreDataLocation] {
        let locations = CoreDataStore.find(entity: CoreDataLocation.self)
        return locations
    }
    
    func fill(_ location: CLLocation) {
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
    
    func fill(_ location: Location) {
        name = location.name
        fullName = location.fullName
        placeId = location.placeId
        lat = location.lat
        lon = location.lon
        imageData = location.imageData
    }
    
    static func save(location: Location) {
        
        let predicates = [NSPredicate(format: "placeId = %@", location.placeId)]
        var coreDataLocation = CoreDataStore.findOne(entity: CoreDataLocation.self, predicates: predicates)

        if coreDataLocation == nil {
            coreDataLocation = CoreDataStore.new(entity: CoreDataLocation.self)
            coreDataLocation?.date = Date()
            coreDataLocation?.fill(location)
            CoreDataStore.save()
        }
        
    }
    
}
