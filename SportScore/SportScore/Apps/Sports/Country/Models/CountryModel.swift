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

    enum CodingKeys: String, CodingKey {
        case fullName = "name_en"
        case flag = "flag_url_32"
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
