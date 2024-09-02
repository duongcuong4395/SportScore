//
//  MapViewModel.swift
//  SportScore
//
//  Created by pc on 30/07/2024.
//

import Foundation
import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.305984, longitude: 103.828292),
            span: MKCoordinateSpan(latitudeDelta: 162.0, longitudeDelta: 137.0)
        )
    )
    
    @Published var mapStyle: MapStyle = .standard
    
    let api: MapsAPIEvent
    
    init() {
        api = MapsAPIEndpoint()
    }
    
    
    func getGeocoding(with query: String, and lang: String, and country: String, completion: @escaping (MapGeocodingModel) -> Void) {
        api.getGeocoding(with: query, and: lang, and: country) { result in
            switch result {
            case .success(let data):
                completion(data.data)
            case .failure(let err):
                print("err", err)
            }
        }
    }
    
    func moveTo(coordinate: CLLocationCoordinate2D, zoom: Double) {
        withAnimation {
            self.position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom)
                )
            )
        }
        
    }
}
