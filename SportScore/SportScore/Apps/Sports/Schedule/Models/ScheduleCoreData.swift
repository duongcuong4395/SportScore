//
//  ScheduleCoreData.swift
//  SportScore
//
//  Created by pc on 14/08/2024.
//

import Foundation
import CoreData

extension ScheduleLeagueModel: ModelCoreData {
    
    typealias Model = Self
    
    typealias objCoreData = ScheduleCD
    
    func convertToCoreData(for context: NSManagedObjectContext) throws -> ScheduleCD {
        let scheduleCD = ScheduleCD(context: context)
        scheduleCD.idEvent = idEvent ?? ""
        scheduleCD.idVenue = idVenue ?? ""
        scheduleCD.idLeague = idLeague ?? ""
        
        scheduleCD.idAwayTeam = idAwayTeam ?? ""
        scheduleCD.awayTeamName = awayTeamName ?? ""
        scheduleCD.awayTeamBadge = awayTeamBadge ?? ""
        scheduleCD.awayScore = awayScore ?? nil
        
        scheduleCD.idHomeTeam = idHomeTeam ?? ""
        scheduleCD.homeTeamName = homeTeamName ?? ""
        scheduleCD.homeTeamBadge = homeTeamBadge ?? ""
        scheduleCD.homeScore = homeScore ?? nil
        
        scheduleCD.thumb = thumb ?? ""
        scheduleCD.banner = banner ?? ""
        scheduleCD.countryName = countryName ?? ""
        scheduleCD.eventAlternateName = eventAlternateName ?? ""
        scheduleCD.eventName = eventName ?? ""
        scheduleCD.leagueName = leagueName ?? ""
        scheduleCD.poster = poster ?? ""
        scheduleCD.seasonName = seasonName ?? ""
        scheduleCD.roundNumber = roundNumber ?? ""
        scheduleCD.sportName = sportName ?? ""
        
        scheduleCD.timestamp = timestamp ?? ""
        scheduleCD.square = square ?? ""
        scheduleCD.venue = venue ?? ""
        scheduleCD.status = status ?? ""
        scheduleCD.isFavorite = isFavorite ?? false
        scheduleCD.isNotify = isNotify ?? false
        
        print("convertToCoreData.eventName: ", scheduleCD.eventName ?? "", eventName ?? "")
        print("convertToCoreData.awayScore: ", scheduleCD.awayScore ?? "", awayScore ?? "")
        print("convertToCoreData.homeScore: ", scheduleCD.homeScore ?? "", homeScore ?? "")
        return scheduleCD
    }
    
    func checkExists(in context: NSManagedObjectContext, complete: @escaping (Bool, [Any]) -> Void) throws {
        
        let condition = NSPredicate (format: "idEvent like %@"
                                      , idEvent ?? "" )
        let modelExists = context.doesEntityExist(ofType: ScheduleCD.self
                                                  , with: condition)
        //self.liked = modelExists.result
        complete(modelExists.result, modelExists.models)
    }
}

extension ScheduleCD {
    func convertToModel() -> ScheduleLeagueModel {
        var obj = ScheduleLeagueModel()
        
        obj.idEvent = idEvent
        obj.eventName = eventName
        obj.seasonName = seasonName
        
        obj.idVenue = idVenue
        obj.idLeague = idLeague
        
        obj.idAwayTeam = idAwayTeam
        obj.awayTeamName = awayTeamName
        obj.awayTeamBadge = awayTeamBadge
        obj.awayScore = awayScore
        
        
        obj.idHomeTeam = idHomeTeam
        obj.homeTeamName = homeTeamName
        obj.homeTeamBadge = homeTeamBadge
        obj.homeScore = homeScore
        
        obj.thumb = thumb
        obj.banner = banner
        obj.countryName = countryName
        obj.eventAlternateName = eventAlternateName
        
        obj.leagueName = leagueName
        obj.poster = poster
        
        obj.roundNumber = roundNumber
        obj.sportName = sportName
        
        obj.timestamp = timestamp
        obj.square = square
        obj.venue = venue
        obj.status = status
        obj.isFavorite = isFavorite// ?? false
        obj.isNotify = isNotify //?? false
        
        print("convertToModel.eventName: ", obj.eventName ?? "", eventName ?? "")
        print("convertToModel.awayScore: ", obj.awayScore ?? "", awayScore ?? "", obj.awayScore == "", awayScore == "")
        print("convertToModel.homeScore: ", obj.homeScore ?? "", homeScore ?? "", obj.homeScore == "", homeScore == "" )
        return obj
    }
}
