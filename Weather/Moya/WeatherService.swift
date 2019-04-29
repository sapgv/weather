//
//  WeatherService.swift
//  Weather
//
//  Created by Sapgv on 28/02/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import Moya
import CoreLocation

enum WeatherService {
    
    case retrieveWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees)

}

extension WeatherService: TargetType {
    
    var baseURL: URL { return URL(string: "http://samples.openweathermap.org/data/2.5")! }
    var path: String {
        switch self {
        case .retrieveWeatherAtLat:
            return "/weather"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        
        switch self {
        case let .retrieveWeatherAtLat(lat, lon):
            return .requestParameters(
                parameters: [
                    "appid": Settings.OpenWeatherKey,
                    "lat": lat,
                    "lon": lon
                ],
                encoding: URLEncoding.queryString
            )
            
        }
        
    }
    var sampleData: Data {
        return Data()
    }
    var headers: [String: String]? {
        return nil
    }
}
