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

//    static let key = "AIzaSyBKhBmc_E9mNmssBUHbES-BD2HubC7jONg"
    var key: String {
        return "AIzaSyBKhBmc_E9mNmssBUHbES-BD2HubC7jONg"
    }
    case search(text: String)
    case placeDetail(placeId: String)
    case photo(photoreference: String, width: Int)
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
        case .photo(_, _):
            return "/photo"
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
                "key": key,
                "types": "geocode",
                "input": text
                ], encoding: URLEncoding.queryString)
        case let .placeDetail(placeId):
            return .requestParameters(parameters: [
                "output": "json",
                "key": key,
                "placeid": placeId,
                "fields": "geometry,photo"
                ], encoding: URLEncoding.queryString)
        case let .photo(photoreference, width):
            return .requestParameters(parameters: [
                "key": key,
                "photoreference": photoreference,
                "maxwidth": width
                ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
