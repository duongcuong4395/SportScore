//
//  ScheduleCD+CoreDataProperties.swift
//  SportScore
//
//  Created by pc on 14/08/2024.
//
//

import Foundation
import CoreData


extension ScheduleCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleCD> {
        return NSFetchRequest<ScheduleCD>(entityName: "ScheduleCD")
    }

    @NSManaged public var idEvent: String?
    @NSManaged public var eventName: String?
    @NSManaged public var eventAlternateName: String?
    @NSManaged public var sportName: String?
    @NSManaged public var idLeague: String?
    @NSManaged public var leagueName: String?
    @NSManaged public var seasonName: String?
    @NSManaged public var roundNumber: String?
    @NSManaged public var idHomeTeam: String?
    @NSManaged public var homeTeamName: String?
    @NSManaged public var homeTeamBadge: String?
    @NSManaged public var homeScore: String?
    @NSManaged public var idAwayTeam: String?
    @NSManaged public var awayTeamName: String?
    @NSManaged public var awayTeamBadge: String?
    @NSManaged public var awayScore: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var thumb: String?
    @NSManaged public var banner: String?
    @NSManaged public var poster: String?
    @NSManaged public var square: String?
    @NSManaged public var idVenue: String?
    @NSManaged public var venue: String?
    @NSManaged public var countryName: String?
    @NSManaged public var status: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var isNotify: Bool

}

extension ScheduleCD : Identifiable {

}
