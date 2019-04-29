//
//  Settings.swift
//  Weather
//
//  Created by Sapgv on 28/02/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation

struct Settings {
    
    
    static let OpenWeatherKey = "5cf79f055f9ded72a34a487b925603b4"
    static let flickrApiKey = "03e2f516fbf6cfb23c29aa83127fc91b"
    
    static func error(_ description: ErrorDefaults) -> NSError {
        return NSError(domain: "Error", code: 1, userInfo: [NSLocalizedDescriptionKey: description.rawValue])
    }
    
}

enum ErrorDefaults: String {
    case FailRetrieveImageCity = "fail to retrieve image of city"
    case CoreDataErrorSave = "failed to save core data"
    case CoreDataFetchError = "failed to fetch data"
}


