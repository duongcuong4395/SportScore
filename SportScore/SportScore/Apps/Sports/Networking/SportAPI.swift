//
//  SportAPI.swift
//  SportScore
//
//  Created by pc on 09/08/2024.
//

import Foundation
import Alamofire

enum NextAndPrevious: String {
    case Next = "next"
    case Previous = "previous"
}

enum SportEndPoint<T: Decodable> {
    // https://www.thesportsdb.com/api/v1/json/3/all_countries.php
    case GetCountries
    // https://www.thesportsdb.com/api/v1/json/3/search_all_leagues.php?c=England
    case GetLeagues(from: CountryModel, by: String) // SportType
    
    /// Get ALL Season by League
    /// https://www.thesportsdb.com/api/v1/json/3/search_all_seasons.php?id=4328
    case GetSeason(from: LeaguesModel)
    /// Get teams of a league
    /// https://www.thesportsdb.com/api/v1/json/3/search_all_teams.php?l=German Bundesliga
    case GetTeams(from: LeaguesModel)
    /// Get Lookup table(rank) of league and Seeson
    /// Ex: https://www.thesportsdb.com/api/v1/json/3/lookuptable.php?l=4328&s=2020-2021
    case GetLookuptable(from: LeaguesModel, and: SeasonModel)
    /// Get Lookup equipments of team by TeamID
    /// Ex: https://www.thesportsdb.com/api/v1/json/3/lookupequipment.php?id=133597
    case GetLookupEquipment(from: TeamModel)
    /// Get all player of a team by teamID
    /// Ex: https://www.thesportsdb.com/api/v2/json/3/list/players/133604
    case GetPlayers(from: TeamModel)
    /// Get Schedule of League by  LeaguesModel
    /// https://www.thesportsdb.com/api/v2/json/3/schedual/next/league/4328
    case GetSchedule(from: LeaguesModel, for: NextAndPrevious)
    
    /// https://www.thesportsdb.com/api/v2/json/3/schedual/next/team/133612
    case GetScheduleByTeam(from: Int, for: NextAndPrevious)
    /// Get Event results by eventID
    /// https://www.thesportsdb.com/api/v1/json/3/eventresults.php?id=1917690
    case GetEventresults(by: String)
    /// Get Player Detail by playerID
    /// https://www.thesportsdb.com/api/v1/json/3/lookupplayer.php?id=34167526
    case GetPlayerDetail(by: String)
    
    /// get last events by teamID
    /// https://www.thesportsdb.com/api/v1/json/3/eventslast.php?id=133602
    case getLastEvent(by: String)
    
    /// Get List event of league into Round by leagueID and round and season
    /// https://www.thesportsdb.com/api/v1/json/3/eventsround.php?id=4406&r=28&s=2023
    case GetListEvent(by: String, in: String, of: String)
    
    /// All events in specific league by season
    /// https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=2014-2015
    case GetEventsInSpecific(by: String, of: String)
    
    /// Get detail of Team
    /// https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=manchester%20united
    case GetTeamDetail(by: String)
 
    /// Search for players by name
    /// api/v1/json/3/searchplayers.php?p=Danny_Welbeck
    case SearchPlayer(by: String)
}




extension SportEndPoint: HttpRouter {
    var baseURL: String {
        AppUtility.SportBaseURL
    }
    
    var path: String {
        switch self {
        case .GetCountries:
            return "api/v1/json/3/all_countries.php"
        case .GetLeagues(from: _, by: _):
            return "api/v1/json/3/search_all_leagues.php"
        case .GetSeason(from: _):
            return "api/v1/json/3/search_all_seasons.php"
        case .GetTeams(from: _):
            return "api/v1/json/3/search_all_teams.php"
        case .GetLookuptable(from: _, and: _):
            return "api/v1/json/3/lookuptable.php"
        case .GetLookupEquipment(from: _):
            return "api/v1/json/3/lookupequipment.php"
        case .GetPlayers(from: let team):
            return "api/v2/json/3/list/players/" + (team.idTeam ?? "")
        case .GetSchedule(from: let league, for: let nextOrPrevious):
            return "api/v2/json/3/schedual/\(nextOrPrevious.rawValue)/league/\(league.idLeague ?? "")"
        case .GetScheduleByTeam(from: let teamID, for: let nextOrPrevious):
            return "api/v2/json/3/schedual/\(nextOrPrevious.rawValue)/team/\(teamID)"
        case .GetEventresults(by: _):
            return "api/v1/json/3/eventresults.php"
        case .GetPlayerDetail(by: _):
            return "api/v1/json/3/lookupplayer.php"
        case .getLastEvent(by: _):
            return "api/v1/json/3/eventslast.php"
        case .GetListEvent(by: _, in: _, of: _):
            return "api/v1/json/3/eventsround.php"
        case .GetEventsInSpecific(by: _, of: _):
            return "api/v1/json/3/eventsseason.php"
        case .GetTeamDetail(by: _):
            return "api/v1/json/3/searchteams.php"
        case .SearchPlayer(by: _):
            return "api/v1/json/3/searchplayers.php"
        }
    }
    
    var menthod: Alamofire.HTTPMethod {
        return .get
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case .GetCountries:
            return nil
        case .GetLeagues(from: let countryModel, by: let sportType):
            if sportType.isEmpty {
                return ["c": countryModel.fullName]
            } else {
                return ["c": countryModel.fullName, "s": sportType]
            }
        case .GetSeason(from: let leaguesModel):
            return ["id": leaguesModel.idLeague ?? ""]
        case .GetTeams(from: let leaguesModel):
            return ["l": leaguesModel.leagueName ?? ""]
        case .GetLookuptable(from: let leaguesModel, and: let seasonModel):
            return ["l": leaguesModel.idLeague ?? "" ,"s":seasonModel.season ?? ""]
        case .GetLookupEquipment(from: let teamModel):
            return ["id": teamModel.idTeam ?? ""]
        case .GetPlayers(from: _):
            return nil
        case .GetSchedule(from: _, for: _):
            return nil
        case .GetScheduleByTeam(from: _, for: _):
            return nil
        case .GetEventresults(by: let eventID):
            return ["id": eventID]
        case .GetPlayerDetail(by: let playerID):
            return ["id": playerID]
        case .getLastEvent(by: let teamID):
            return ["id": teamID]
        case .GetListEvent(by: let leagueID, in: let round, of: let season):
            return ["id": leagueID, "r": round, "s": season]
        case .GetEventsInSpecific(by: let leagueID, of: let season):
            return ["id": leagueID, "s": season]
        case .GetTeamDetail(by: let teamName):
            return ["t": teamName]
        case .SearchPlayer(by: let name):
            return ["p": name]
        }
    }
    
    var body: Data? {
        nil
    }
    
    typealias responseDataType = T
}

protocol SportAPIEvent {
    func getCountries<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void)
    func getLeagues<T: Decodable>(from country: CountryModel
                                  , by sportType: String
                                  , completion: @escaping (Result<T, Error>) -> Void)
    func getSeason<T: Decodable>(from leagues: LeaguesModel, completion: @escaping (Result<T, Error>) -> Void)
    func getTeams<T: Decodable>(from leagues: LeaguesModel, completion: @escaping (Result<T, Error>) -> Void)
    
    func getPlayers<T: Decodable>(from team: TeamModel, completion: @escaping (Result<T, Error>) -> Void)
    
    func getLookuptable<T: Decodable>(from leagues: LeaguesModel, and season: SeasonModel, completion: @escaping (Result<T, Error>) -> Void)
    func getLookupEquipment<T: Decodable>(from team: TeamModel, completion: @escaping (Result<T, Error>) -> Void)
    
    func getSchedule<T: Decodable>(from league: LeaguesModel, for dateGet: NextAndPrevious, completion: @escaping (Result<T, Error>) -> Void)
    
    func getSchedule<T: Decodable>(by teamID: Int, for dateGet: NextAndPrevious, completion: @escaping (Result<T, Error>) -> Void)
    
    func performRequest<T: Decodable>(for api: SportEndPoint<T>, completion: @escaping (Result<T, Error>) -> Void)
    
    
    func getEventresults<T: Decodable>(by eventID: String, completion: @escaping (Result<T, Error>) -> Void)
    func getPlayerDetail<T: Decodable>(by playerID: String, completion: @escaping (Result<T, Error>) -> Void)
    
    func getLastEvent<T: Decodable>(by teamID: String, completion: @escaping (Result<T, Error>) -> Void)
    func getListEvent<T: Decodable>(by leagueID: String, in round: String, of season: String, completion: @escaping (Result<T, Error>) -> Void)
    
    func getEventsInSpecific<T: Decodable>(by leagueID: String, of season: String, completion: @escaping (Result<T, Error>) -> Void)
    
    func getTeamDetail<T: Decodable>(by teamName: String, completion: @escaping (Result<T, Error>) -> Void)
    func searchPlayer<T: Decodable>(by playerName: String, completion: @escaping (Result<T, Error>) -> Void)
    
    // MARK: - FOR Async/Await
    func getCountries<T: Decodable>() async throws -> T
    func getLeagues<T: Decodable>(from country: CountryModel, by sportType: String) async throws -> T
    func getSeason<T: Decodable>(from league: LeaguesModel) async throws -> T
    func getTeams<T: Decodable>(from league: LeaguesModel) async throws -> T
    func getPlayers<T: Decodable>(from team: TeamModel) async throws -> T
    func getSchedule<T: Decodable>(from league: LeaguesModel, for dateGet: NextAndPrevious) async throws -> T
    func getEventResults<T: Decodable>(by eventID: String) async throws -> T
    func getPlayerDetail<T: Decodable>(by playerID: String) async throws -> T
    
}

// MARK: - For Async/Await
extension SportAPIEvent {
    func performRequest<T: Decodable>(for api: SportEndPoint<T>) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            let request = APIRequest(router: api)
            request.callAPI { result in
                switch result {
                case .Successs(let data):
                    continuation.resume(returning: data)
                case .Failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getPlayerDetail<T: Decodable>(by playerID: String) async throws -> T {
        return try await performRequest(for: .GetPlayerDetail(by: playerID))
    }

    func getEventResults<T: Decodable>(by eventID: String) async throws -> T {
        return try await performRequest(for: .GetEventresults(by: eventID))
    }

    func getCountries<T: Decodable>() async throws -> T {
        return try await performRequest(for: .GetCountries)
    }

    func getLeagues<T: Decodable>(from country: CountryModel, by sportType: String) async throws -> T {
        return try await performRequest(for: .GetLeagues(from: country, by: sportType))
    }

    func getSeason<T: Decodable>(from league: LeaguesModel) async throws -> T {
        return try await performRequest(for: .GetSeason(from: league))
    }

    func getTeams<T: Decodable>(from league: LeaguesModel) async throws -> T {
        return try await performRequest(for: .GetTeams(from: league))
    }
    
    func getPlayers<T: Decodable>(from team: TeamModel) async throws -> T {
        return try await performRequest(for: .GetPlayers(from: team))
    }

    func getSchedule<T: Decodable>(from league: LeaguesModel, for dateGet: NextAndPrevious) async throws -> T {
        return try await performRequest(for: .GetSchedule(from: league, for: dateGet))
    }
}

extension SportAPIEvent {
    func performRequest<T: Decodable>(for api: SportEndPoint<T>, completion: @escaping (Result<T, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
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
    func getPlayerDetail<T: Decodable>(by playerID: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetPlayerDetail(by: playerID), completion: completion)
    }
    
    
    func getEventresults<T: Decodable>(by eventID: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetEventresults(by: eventID), completion: completion)
    }
    
    func getSchedule<T: Decodable>(by teamID: Int, for dateGet: NextAndPrevious, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetScheduleByTeam(from: teamID, for: dateGet), completion: completion)
    }
    
    func getCountries<T: Decodable>(completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetCountries, completion: completion)
    }
    
    func getLeagues<T: Decodable>(from country: CountryModel
                                  , by sportType: String
                                  , completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetLeagues(from: country, by: sportType), completion: completion)
    }
    
    func getSeason<T: Decodable>(from leagues: LeaguesModel, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetSeason(from: leagues), completion: completion)
    }
    
    func getTeams<T: Decodable>(from leagues: LeaguesModel, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetTeams(from: leagues), completion: completion)
    }
    
    func getLookuptable<T: Decodable>(from leagues: LeaguesModel, and season: SeasonModel, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetLookuptable(from: leagues, and: season), completion: completion)
    }
    
    func getLookupEquipment<T: Decodable>(from team: TeamModel, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetLookupEquipment(from: team), completion: completion)
    }
    
    func getPlayers<T: Decodable>(from team: TeamModel, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetPlayers(from: team), completion: completion)
    }
    
    func getSchedule<T: Decodable>(from league: LeaguesModel, for dateGet: NextAndPrevious, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetSchedule(from: league, for: dateGet), completion: completion)
    }
    
    func getLastEvent<T: Decodable>(by teamID: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .getLastEvent(by: teamID), completion: completion)
    }
    
    func getListEvent<T: Decodable>(by leagueID: String, in round: String, of season: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetListEvent(by: leagueID, in: round, of: season), completion: completion)
    }
    
    func getEventsInSpecific<T: Decodable>(by leagueID: String, of season: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetEventsInSpecific(by: leagueID, of: season), completion: completion)
    }
    
    func getTeamDetail<T: Decodable>(by teamName: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .GetTeamDetail(by: teamName), completion: completion)
    }
    
    func searchPlayer<T: Decodable>(by playerName: String, completion: @escaping (Result<T, Error>) -> Void) {
        performRequest(for: .SearchPlayer(by: playerName), completion: completion)
    }
}

