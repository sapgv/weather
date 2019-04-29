//
//  WeatherDataStore.swift
//  Weather
//
//  Created by Sapgv on 28/02/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDataSource {

    func retrieveCurrentWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees)
//    func retrieveHourlyForecastAtLat(llat: CLLocationDegrees, lon: CLLocationDegrees)
//    func retrieveDailyForecastAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees)
    
}

class WeatherDataStore: WeatherDataSource {
    
    func retrieveCurrentWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        
    }
    
    
    
    
    
    
}
