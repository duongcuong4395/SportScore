//
//  CountryModel.swift
//  SportScore
//
//  Created by pc on 09/08/2024.
//

import Foundation


enum ImageSize: String {
    case Min = "32"
    case Medium = "64"
}

// MARK: - TwoHourWeatherForecast
struct CountryResponse: Codable {
    var countries: [CountryModel]
}

// MARK: - Country
struct CountryModel: Codable, Identifiable {
    var id: UUID = UUID()
    var fullName: String
    var flag: String
    
    var lat: Double?
    var lng: Double?
    var timezone: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "name_en"
        case flag = "flag_url_32"
        case lat, lng, timezone
    }
    
    func getFlag(by size: ImageSize) -> String {
        switch size {
        case .Min:
            return flag
        case .Medium:
            return flag.replacingOccurrences(of: "32", with: "64")
        }
        
    }
}


import MapKit

extension CountryModel: MarkerData {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: lng ?? 0.0)
    }
    
    var title: String {
        fullName
    }
    
    func getIconView() -> AnyView {
        return CountryMarkerIConView(model: self).toAnyView()
    }
    
    func getDetailView() -> AnyView {
        return EmptyView().toAnyView()
    }
    
    func getMarkerType() -> MarkerType {
        .Country
    }
    
    func getMarkerModel() -> MarkerModel {
        return MarkerModel(model: self)
    }
    
    
}

struct CountryMarkerIConView: View {
    var model: CountryModel
    var body: some View {
        VStack(spacing: 0) {
            /*
            Text(model.fullName)
                .font(.caption2)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .padding(0)
             */
            KFImage(URL(string: model.getFlag(by: .Medium)))
                .placeholder {
                    LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                }
                .resizable()
                .scaledToFit()
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .frame(width: 30, height: 30)
                .padding(0)
        }
    }
}

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension CountryModel {
    func getItemView(with optionView: () -> some View) -> some View {
        VStack {
            KFImage(URL(string: getFlag(by: .Medium)))
                .placeholder {
                    LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                }
                .font(.caption)
            
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .frame(width: 50, height: 50)
            Text(fullName)
                .font(.caption)
                
            optionView()
        }
    }
}
