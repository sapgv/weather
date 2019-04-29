//
//  FlickrService.swift
//  Weather
//
//  Created by Sapgv on 06/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import Moya
import CoreLocation

enum FlickrService {
    
    case imageAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees)
    
}

extension FlickrService: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.flickr.com/services/rest/")! }
    var path: String {
        return ""
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        
        switch self {
        case let .imageAtLat(lat, lon):
            return .requestParameters(
                parameters: [
                    "method": "flickr.photos.search",
                    "api_key": Settings.flickrApiKey,
                    "lat": lat,
                    "lon": lon,
                    "format": "json",
                    "per_page": 1,
                    "nojsoncallback": 1
                ],
                encoding: URLEncoding.queryString
            )
            
        }
        
    }
    var sampleData: Data {
        return Data()
    }
//    var headers: [String: String]? {
//        return nil
//    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
}
