//
//  ScheduleModel.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import Foundation


struct EventsResponse: Codable {
    var events: [ScheduleLeagueModel]?
}

struct LastEventsResponse: Codable {
    var results: [ScheduleLeagueModel]?
}

struct ScheduleLeagueResponse: Codable {
    var scheduleLeagues: [ScheduleLeagueModel]?

    enum CodingKeys: String, CodingKey {
        case scheduleLeagues = "1"
    }
}

struct ScheduleLeagueModel: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    
    var idEvent: String?
    var idSoccerXML: String?
    var idAPIfootball, eventName, eventAlternateName, filename: String?
    var sportName, idLeague, leagueName, seasonName: String?
    var descriptionEN, homeTeamName, awayTeamName: String?
    var homeScore: String?
    var roundNumber: String?
    var awayScore, spectators: String?
    var officialName, timestamp, dateEvent, dateEventLocal: String?
    var dateEventEnd, time, timeLocal, group: String?
    var idHomeTeam: String?
    var homeTeamBadge: String?
    var idAwayTeam: String?
    var awayTeamBadge: String?
    var intScore, intScoreVotes: String?
    var strResult, idVenue, venue, countryName: String?
    var cityName: String?
    var poster, square: String?
    var fanart: String?
    var thumb, banner: String?
    var mapLoc: String?
    var tweet1, tweet2, tweet3, video: String?
    var status, postponed, locked: String?
    
    var isFavorite: Bool? = false
    var isNotify: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case idEvent = "idEvent"
        case idSoccerXML = "idSoccerXML"
        case idAPIfootball = "idAPIfootball"
        case eventName = "strEvent"
        case eventAlternateName = "strEventAlternate"
        case filename = "strFilename"
        case sportName = "strSport"
        case idLeague = "idLeague"
        case leagueName = "strLeague"
        case seasonName = "strSeason"
        case descriptionEN = "strDescriptionEN"
        case homeTeamName = "strHomeTeam"
        case awayTeamName = "strAwayTeam"
        case homeScore = "intHomeScore"
        case roundNumber = "intRound"
        case awayScore = "intAwayScore"
        case spectators = "intSpectators"
        case officialName = "strOfficial"
        case timestamp = "strTimestamp"
        case dateEvent = "dateEvent"
        case dateEventLocal = "dateEventLocal"
        case dateEventEnd = "dateEventEnd"
        case time = "strTime"
        case timeLocal = "strTimeLocal"
        case group = "strGroup"
        case idHomeTeam = "idHomeTeam"
        case homeTeamBadge = "strHomeTeamBadge"
        case idAwayTeam = "idAwayTeam"
        case awayTeamBadge = "strAwayTeamBadge"
        case intScore = "intScore"
        case intScoreVotes = "intScoreVotes"
        case strResult = "strResult"
        case idVenue = "idVenue"
        case venue = "strVenue"
        case countryName = "strCountry"
        case cityName = "strCity"
        case poster = "strPoster"
        case square = "strSquare"
        case fanart = "strFanart"
        case thumb = "strThumb"
        case banner = "strBanner"
        case mapLoc = "strMap"
        case tweet1 = "strTweet1"
        case tweet2 = "strTweet2"
        case tweet3 = "strTweet3"
        case video = "strVideo"
        case status = "strStatus"
        case postponed = "strPostponed"
        case locked = "strLocked"
    }
    
}

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension ScheduleLeagueModel {
    
    func getItemView(and optionsView: @escaping () -> some View) -> some View {
        ZStack {
            SportEventItemView(model: self, optionView: optionsView().toAnyView())
        }
    }
}



