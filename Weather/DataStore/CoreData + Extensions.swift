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
    
    func fill(_ location: SearchLocation) {
        name = location.name
        fullName = location.fullName
        placeId = location.placeId
        lat = location.lat
        lon = location.lon
        
    }
    
    static func save(searchLocation: SearchLocation) {
        
        let predicates = [NSPredicate(format: "placeId = %@", searchLocation.placeId)]
        let entityName = Location.self.entityName
        print(entityName)
        var location = CoreDataStore.findOne(entity: Location.self, predicates: predicates)

        if location == nil {
            location = CoreDataStore.new(entity: Location.self)
            location?.date = Date()
            location?.fill(searchLocation)
            CoreDataStore.save()
        }
        
    }
    
}
