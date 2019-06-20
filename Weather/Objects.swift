//
//  Objects.swift
//  Weather
//
//  Created by Sapgv on 28/02/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation

struct Location {
    
    let name: String
    let fullName: String
    var placeId : String = ""
    var imageData: Data?
    var lat: Double = 0
    var lon: Double = 0
    var weather: Weather?
    
    init(name: String, fullName: String) {
        self.name = name
        self.fullName = fullName
    }
    
    init(location: CoreDataLocation) {
        self.name = location.name ?? ""
        self.fullName = location.fullName ?? ""
        self.placeId = location.placeId ?? ""
        self.imageData = location.imageData
        self.lat = location.lat
        self.lon = location.lon
    }
    
    init(_ data: [String: AnyObject]) throws {
        self.name = try unwrap(try unwrap(data["structured_formatting"] as? [String: AnyObject])["main_text"] as? String)
        self.fullName = try unwrap(data["description"] as? String)
        self.placeId = try unwrap(data["place_id"] as? String)
    }
    
    static func findAll() -> [Location] {
        return CoreDataLocation.findAll().map {
            Location(location: $0)
        }
    }
}

struct Weather {
    
    let description: String
    let temperature: Double
    
    
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
