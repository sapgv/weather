//
//  GoogleAutocompletionService.swift
//  Weather
//
//  Created by Sapgv on 16/04/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import Moya

enum GoogleAutocompletionService {
    case search(text: String)
    case placeDetail(placeId: String)
}

extension GoogleAutocompletionService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://maps.googleapis.com/maps/api/place")!
    }
    
    var path: String {
        
        switch self {
        case .search(_):
            return "/autocomplete/json"
        case .placeDetail(_):
            return "/details/json"
        }
        
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        
        switch self {
        case let .search(text):
            return .requestParameters(parameters: [
                "output": "json",
                "key": "AIzaSyBKhBmc_E9mNmssBUHbES-BD2HubC7jONg",
                "types": "geocode",
                "input": text
                ], encoding: URLEncoding.queryString)
        case let .placeDetail(placeId):
            return .requestParameters(parameters: [
                "output": "json",
                "key": "AIzaSyBKhBmc_E9mNmssBUHbES-BD2HubC7jONg",
                "placeid": placeId,
                "fields": "geometry"
                ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
