//
//  Objects.swift
//  Weather
//
//  Created by Sapgv on 28/02/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation

struct WeatherCondition {
    
    var time: NSDate
    var city: String
    var weatherDescription: String
    var minTempKelvin: Int
    var maxTempKelvin: Int
    
}

struct SearchLocation {
    var name: String
    var fullName: String
    var placeId : String
    var lat: Double
    var lon: Double
    
    init(_ data: [String: AnyObject]) throws {
        self.name = try unwrap(try unwrap(data["structured_formatting"] as? [String: AnyObject])["main_text"] as? String)
        self.fullName = try unwrap(data["description"] as? String)
        self.placeId = try unwrap(data["place_id"] as? String)
        self.lat = 0
        self.lon = 0
    }
}


public func unwrap<T>(_ optional: T?) throws -> T  {
    if let real = optional {
        return real
    }
    else {
        throw UnwrapErrorObsolete(optional: optional)
    }
    
}

public struct UnwrapErrorObsolete<T>: Error, CustomStringConvertible {
    
    let optional: T?
    public var description: String {
        return "Found nil while unwrapping: \(String(describing: optional)) for type: \(T.self)"
    }
}
