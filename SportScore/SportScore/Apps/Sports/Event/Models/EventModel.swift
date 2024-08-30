//
//  EventModel.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import Foundation


// MARK: - TwoHourWeatherForecast
struct EventResponse: Codable {
    var players: [PlayerEventModel]?
    
    enum CodingKeys: String, CodingKey {
        case players = "results"
    }
}

// MARK: - Result
struct PlayerEventModel: Codable {
    var idResult, idPlayer, playerName, idTeam: String?
    var idEvent: String?
    var eventName: String?
    var result: String?
    var position, points: String?
    var detail: String?
    var dateEvent, season: String?
    var country: String?
    var sport: String?
    
    enum CodingKeys: String, CodingKey {
        case idResult, idPlayer, idTeam, idEvent
        case playerName = "strPlayer"
        
        case eventName = "strEvent"
        case result = "strResult"
        case position = "intPosition"
        case points = "intPoints"
        case detail = "strDetail"
        case dateEvent
        case season = "strSeason"
        case country = "strCountry"
        case sport = "strSport"
    }
}
