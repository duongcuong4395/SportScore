//
//  EquipmentModel.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import Foundation


struct EquipmentResponse: Codable {
    var equipment: [EquipmentModel]?
}

// MARK: - Equipment
struct EquipmentModel: Codable, Identifiable {
    var id: UUID = UUID()
    var idEquipment, idTeam, date, season: String?
    var equipment: String?
    var typeName, username: String?
    
    enum CodingKeys: String, CodingKey {
        case idEquipment, idTeam, date
        case season = "strSeason"
        case equipment = "strEquipment"
        case typeName = "strType"
        case username = "strUsername"
    }
}


import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension EquipmentModel {
    
    func getItemVIew() -> some View {
        VStack {
            KFImage(URL(string: equipment ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
            Text(season ?? "")
                .font(.callout.bold())
        }
    }
}
