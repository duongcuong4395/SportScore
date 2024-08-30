//
//  SeasonModel.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import Foundation


struct SeasonResponse: Codable {
    var seasons: [SeasonModel]?
}

// MARK: - Season
struct SeasonModel: Codable {
    var season: String?
    
    enum CodingKeys: String, CodingKey {
        case season = "strSeason"
    }
}



struct LookuptableResponse: Codable {
    var table: [RankModel]?
}

// MARK: - Table
struct RankModel: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var idStanding, intRank, idTeam, teamName: String?
    var badge: String?
    var idLeague: String?
    var leagueName: String?
    var season: String?
    var form: String?
    var description: String?
    var playedNumber, winNumber, lossNumber, drawNumber: String?
    var goalsFor, goalsAgainst, goalDifference, pointsNumber: String?
    var dateUpdated: String?
    
    enum CodingKeys: String, CodingKey {
        case idStanding, intRank, idTeam
        case teamName = "strTeam"
        case badge =  "strBadge"
        case idLeague
        case leagueName = "strLeague"
        case season = "strSeason"
        case form = "strForm"
        case description = "strDescription"
        case playedNumber = "intPlayed"
        case winNumber = "intWin"
        case lossNumber = "intLoss"
        case drawNumber = "intDraw"
        case goalsFor = "intGoalsFor"
        case goalsAgainst = "intGoalsAgainst"
        case goalDifference = "intGoalDifference"
        case pointsNumber = "intPoints"
        case dateUpdated
    }
}
