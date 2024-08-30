//
//  MapNetWorking.swift
//  SportScore
//
//  Created by pc on 30/07/2024.
//

import Foundation
import Alamofire

enum MapsAPI<T: Decodable> {
    case GetGeocoding(with: String, and: String, then: String) // with query and lang
}


extension MapsAPI: HttpRouter {
    var baseURL: String {
        AppUtility.MapsBaseURL
    }
    
    var path: String {
        switch self {
        case .GetGeocoding(with: _, and: _, then: _):
            return "geocoding.php"
        }
    }
    
    var menthod: Alamofire.HTTPMethod {
        switch self {
        case .GetGeocoding(with: _, and: _, then: _):
            return .get
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return AppUtility.headersMaps
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .GetGeocoding(with: let query, and: _, then: let country):
            return ["query": query, "lang": "en", "country": country]
        }
    }
    
    var body: Data? {
        nil
    }
    
    typealias responseDataType = T
}


protocol MapsAPIEvent {
    func getGeocoding(with query: String, and lang: String, and country: String, completion: @escaping (Result<MapGeocodingResponse, Error>) -> Void) // with query and lang
}


class MapsAPIEndpoint: MapsAPIEvent {
    func getGeocoding(with query: String, and lang: String, and country: String, completion: @escaping (Result<MapGeocodingResponse, Error>) -> Void) {
        let api = MapsAPI<MapGeocodingResponse>.GetGeocoding(with: query, and: lang, then: country)
        
        let request = APIRequest(router: api)
        request.callAPI { result in
            switch result {
            case .Successs(let data):
                completion(.success(data))
            case .Failure(let err):
                completion(.failure(err))
            }
        }
    }
}
