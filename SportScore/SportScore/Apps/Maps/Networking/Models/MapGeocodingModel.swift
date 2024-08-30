//
//  MapGeocodingModel.swift
//  SportScore
//
//  Created by pc on 30/07/2024.
//

import Foundation


struct MapGeocodingResponse: Decodable {
    var data: MapGeocodingModel
}


struct MapGeocodingModel: Codable, Hashable {
    var address: String
    var lat, lng: Double
    var timezone: String
    
    init() {
        self.address = ""
        self.lat = 0
        self.lng = 0
        self.timezone = ""
    }
}
