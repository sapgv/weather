//
//  LocationService.swift
//  Weather
//
//  Created by Sapgv on 06/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class LocationService: NSObject {
    
    private override init() {}
    
    static let shared = LocationService()
    
    let geocoder: CLGeocoder = CLGeocoder()
    
    //MARK: - Wnen in use
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self
        return manager
    }()
    
    var didUpdateLocations: ((_ locations: [CLLocation]) -> Void)?
    
    func requestLocation(_ didUpdateLocationsClosure: ((_ locations: [CLLocation]) -> Void)? ) {
        
        didUpdateLocations = didUpdateLocationsClosure
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func geocode(location: CLLocation, completion: @escaping (_ name: String?) -> Void) {
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality)
        }
        
    }
    
    //MARK: - Background
    
    lazy var backgroundLocationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    var didUpdateLocationsBackground: ((_ locations: [CLLocation]) -> Void)?

    func location() -> Promise<CLLocation> {
        
        return Promise { seal in
            requestLocation {
                seal.fulfill($0.first!)
            }
        }
    }
    
    func geocode(location: CLLocation) -> Promise<String> {
        return Promise { seal in
        
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                seal.resolve(placemarks?.first?.locality, error)
            }
        }
        
    }
    
//    var currentLocation: Location {
//        
//    }
    
}



extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            manager.requestLocation()
        }
        else if status == CLAuthorizationStatus.authorizedAlways {
            manager.startUpdatingLocation()
        }
        else {
            //not granted
            print("location service not granted")
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        switch manager.allowsBackgroundLocationUpdates {
        case true:
            didUpdateLocationsBackground?(locations)
        case false:
            didUpdateLocations?(locations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //handle error
    }
}
