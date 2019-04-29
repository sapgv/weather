//
//  FlickrDataStore.swift
//  Weather
//
//  Created by Sapgv on 04/03/2019.
//  Copyright © 2019 Sapgv. All rights reserved.
//

import Foundation
import UIKit
import Moya
import CoreLocation

protocol FlickrDataStoreProtocol {
    func imageAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (_ image: UIImage?, _ error: NSError) ->Void)
}

class FlickrDataStore: FlickrDataStoreProtocol {

    private init() {}
    
    static let shared = FlickrDataStore()
    let provider = MoyaProvider<FlickrService>()
    
    func imageUrl(_ data: [String: Any]) -> String {
        
        let farmId = data["farm-id"] as! String
        let serverId = data["server-id"] as! String
        let id = data["id"] as! String
        let secret = data["secret"] as! String
        
        return "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_{\(secret).jpg"
    }
    
    func imageAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (_ image: UIImage?, _ error: NSError) ->Void) {
        
        provider.request(.imageAtLat(lat: lat, lon: lon)) { result in
            
            switch result {
            case let .success(response):
                do {
                    print(try response.mapJSON() as! [String: Any])
//                    let data = try response.mapJSON() as! [String: Any]
//                    print(data)
                }
                catch let error {
                    print(error)
                    // show an error to your user
                }
            case let .failure(error):
                print(error)
                completion(nil, Settings.error(.FailRetrieveImageCity))
            }
        }
        
        
    }
    
//    private var flickr: FlickrKit = {
//
//        let flickrApiKey = "03e2f516fbf6cfb23c29aa83127fc91b"
//        let flickrSecretKey = "ba486f159ec57d45"
//        let flickr = FlickrKit.shared()
//
//        flickr.initialize(withAPIKey: flickrApiKey, sharedSecret: flickrSecretKey)
//        return flickr
//
//    }()
//
//    static let shared = FlickrDatastore()
//
//    private init() {}
//
//    public func retrieveImageAtLat(lat: Double, lon: Double, closure: (_ image:
//        UIImage?) -> Void) {
//
//
//        flickr.call(<#T##apiMethod: String##String#>, args: <#T##[AnyHashable : Any]?#>, completion: <#T##FKAPIRequestCompletion?##FKAPIRequestCompletion?##([String : Any]?, Error?) -> Void#>)
////        flickr.call("flickr.photos.search", args: [
////            "lat": lat,
////            "lon": lon
////        ]) { (response, error) in
////
////                print(response)
////
////        }
//
//
//
//    }
}
