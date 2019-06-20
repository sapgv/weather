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
    
    case retrieveWeatherAtLat(lat: Double, lon: Double)

}

extension WeatherService: TargetType {
    
    var baseURL: URL { return URL(string: "http://api.openweathermap.org/data/2.5")! }
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
                    "lon": lon,
                    "units": "metric",
                    "lang": "ru"
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

extension WeatherService {
    
    static func retrieveWeatherAtLat(for location: Location, _ completion: @escaping (_ weather: Weather?, _ error: NSError?) -> Void) {
        
        let provider = MoyaProvider<Self>()
        
        provider.request(.retrieveWeatherAtLat(lat: location.lat, lon: location.lon)) { result in
            switch result {
                
            case let .success(response):
                
                do {
                    let data = try response.mapJSON() as! [String: Any]
                    print(data)
                }
                catch {
                    // show an error to your user
                }
                
            case let .failure(error):
                //TO DO
                completion(nil,nil)
                print(error)
            }
        }
    }
    
}
