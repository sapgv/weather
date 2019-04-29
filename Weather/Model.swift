//
//  Model.swift
//  Weather
//
//  Created by Sapgv on 04/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import CoreLocation
import Moya
import PromiseKit

protocol ViewModelProtocol {
    
    func retrieveWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees)
    func retrieveImageAtlat(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (_ image: UIImage?) -> Void)
    func retrieveLocation(completion: @escaping (_ location: CLLocation?) -> Void)
    
}

class ViewModel {
    
    //
    //1 Retrive specific weather for location
    //2 Retrieve weather for all locations
    
//    var current: Location? {
//
////        LocationService.shared
////            .location()
////            .then { location2 in
//////                LocationService.shared.geocode(location: location)
////            }.done {
////                name in
//////                print(location2)
////
////            }
//
////        CLLocationManager.start
//
//
//
//
//    }
    
    var locations: [Location] = []
//    var locations: [Location] = {
//        return CoreDataStore.find(entity: Location.self)
//    }()
    
    var weather: WeatherCondition?
    var weatherClosure: ((_ data: [String: Any]) -> Void)?
    var location: CLLocation? {
        didSet {
            retrieveWeather(at: location!) {
                data in
            }
        }
    }
    
    func retrieveLocation(completion: @escaping (CLLocation) -> Void) {
        
        LocationService.shared.requestLocation { locations in
            completion(locations.first!)
        }
    }
    
    
    
    func retrieveWeather(completion: @escaping () -> Void) {
        
        LocationService.shared.location()
            .then { location in
                LocationService.shared.geocode(location: location)
            }.done { (name) in
                print(name)
        }
        
//        retrieveLocation { location in
//            print("location: \(location))")
//            self.retrieveWeather(at: location) {
//                data in
//                print("data: \(String(describing: data)))")
//                completion()
//            }
//        }
        
    }
    
    func retrieveWeather(completion: @escaping (_ weather: WeatherCondition) -> Void) {
        
        retrieveLocation { location in
            print("location: \(location))")
            self.retrieveWeather(at: location) {
                data in
                print("data: \(String(describing: data)))")
            }
        }
        
        
    }
    
    func retriveLocationGeocode() {
        
        retrieveLocation { location in
            
            LocationService.shared.geocode(location: location) { name in
                
            }
        }
    }
    
    
    func retrieveWeather(at location: CLLocation, completion: @escaping (_ data: [String: Any]?) -> Void) {
        
        provider.request(.retrieveWeatherAtLat(lat: location.coordinate.latitude, lon: location.coordinate.longitude)) { result in
            
            switch result {
                
            case let .success(response):
                
                do {
                    let data = try response.mapJSON() as! [String: Any]
//                    print(data)
                    completion(data)
                }
                catch {
                    // show an error to your user
                    completion(nil)
                }
                
            case let .failure(error):
                print(error)
                completion(nil)
            }
            
        }
    }
    
    
    
    
    
    
    let provider = MoyaProvider<WeatherService>()
    
    func retrieveWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
        provider.request(.retrieveWeatherAtLat(lat: lat, lon: lon)) { result in
            
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
                print(error)
            }
            
        }
        
    }
    
    func updateCurrentWeather() {
        
        LocationService.shared.requestLocation { locations in
            
            if let location = locations.last {
                self.retrieveWeatherAtLat(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
            }
            
        }
        
        
    }
    
    
    
    
    
}
