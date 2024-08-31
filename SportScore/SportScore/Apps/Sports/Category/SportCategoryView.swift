//
//  SportCategoryView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import Foundation
import SwiftUI

enum SportPage: String, CaseIterable {
    case Country
    case Leagues
    case LeaguesDetail
    case Event
    case EventDetail
    case Team
    case TeamDetail
    
    
    func getCurrentPage() -> SportPage? {
        switch self {
        case .Country:
            return .Leagues
        case .Leagues:
            return .LeaguesDetail
        case .LeaguesDetail:
            return nil
        case .Event:
            return .EventDetail
        case .EventDetail:
            return nil
        case .Team:
            return .TeamDetail
        case .TeamDetail:
            return nil
        }
    }
}

/*
 List country
 List League
 List Team
 List Event
 List Season
 List Ranks
 List Event per Round
 */


/*
 [
 (pageSelected: nil, currentPage: List Country),
 (pageSelected: Item Country, currentPage: List League),
 (pageSelected: Item League, currentPage: League Detail),
 
 (pageSelected: Item Event, currentPage: Event Detail),
 (pageSelected: Item Team, currentPage: Team Detail),
 ]
 */

// MARK: - For Item Menu 
extension SportType {
    func getItemMenuView(by page: SportPage) -> AnyView {
        switch self {
        case .Motorsport:
            switch page {
                case .Country:
                    return MotorsportCountryItemMenuView().toAnyView()
                case .Leagues:
                    return MotorsportLeagueItemMenuView().toAnyView()
                case .LeaguesDetail:
                    return EmptyView().toAnyView()
                case .Event:
                return MotorsportEventItemMenuView().toAnyView()
                case .Team:
                    return MotorsportTeamItemMenuView().toAnyView()
                case .TeamDetail:
                    return EmptyView().toAnyView()
                case .EventDetail:
                    return MotorsportEventItemMenuView().toAnyView()
            }
        case .Soccer:
            switch page {
                case .Country:
                    return SoccerCountryItemMenuView().toAnyView()
                case .Leagues:
                    return SoccerLeaguesItemMenuView().toAnyView()
                case .LeaguesDetail:
                    return EmptyView().toAnyView()
                case .Event:
                    return EmptyView().toAnyView()
                case .Team:
                    return SoccerTeamItemMenuView().toAnyView()
                case .TeamDetail:
                    return EmptyView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Darts:
            switch page {
                case .Country:
                    return DartsCountryItemMenuView().toAnyView()
                case .Leagues:
                    return DartsLeagueItemMenuView().toAnyView()
                case .LeaguesDetail:
                    return EmptyView().toAnyView()
                case .Event:
                    return EmptyView().toAnyView()
                case .Team:
                    return SoccerTeamItemMenuView().toAnyView()
                case .TeamDetail:
                    return EmptyView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Fighting:
            switch page {
                case .Country:
                    return FightingCountryItemMenuView().toAnyView()
                case .Leagues:
                    return FightingLeagueItemMenuView().toAnyView()
                case .LeaguesDetail:
                    return EmptyView().toAnyView()
                case .Event:
                    return EmptyView().toAnyView()
                case .Team:
                    return FightingTeamItemMenuView().toAnyView()
                case .TeamDetail:
                    return EmptyView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Baseball, .Basketball, .AmericanFootball, .IceHockey, .Golf
            , .Rugby, .Tennis, .Cricket, .Cycling, .AustralianFootball, .Esports
            , .Volleyball, .Netball, .Handball, .Snooker, .FieldHockey, .Athletics
            , .Badminton, .Climbing, .Equestrian, .Gymnastics, .Shooting
            , .ExtremeSports, .TableTennis, .MultiSports, .Watersports
            , .Weightlifting, .Skiing, .Skating, .Wintersports
            , .Lacrosse, .Gambling:
            
            return EmptyView().toAnyView()
        }
    }
}

// MARK: - For Page
extension SportType {
    
    func getView(by page: SportPage) -> AnyView {
        switch self {
        case .Motorsport:
            switch page {
                case .Country:
                    return MotorsportCountryView().toAnyView()
                case .Leagues:
                    return MotorsportLeaguePageView().toAnyView()
                case .Team:
                    //return MotorsportTeamView().toAnyView()
                    return EmptyView().toAnyView()
                case .Event:
                    return MotorsportEventView().toAnyView()
                case .LeaguesDetail:
                    return MotorsportLeagueDetailView().toAnyView()
                case .TeamDetail:
                    return MotorsportTeamDetailView().toAnyView()
                case .EventDetail:
                    return MotorsportEventDetailView().toAnyView()
            }
        case .Soccer:
            switch page {
                case .Country:
                    return SoccerCountryView().toAnyView()
                case .Leagues:
                    return SoccerLeaguesView().toAnyView()
                case .Team:
                    return EmptyView().toAnyView()
                    //return SoccerTeamDetailView().toAnyView()
                case .Event:
                    return SoccerScheduleView().toAnyView()
                case .LeaguesDetail:
                    return SoccerLeaguesDetailView().toAnyView()
                case .TeamDetail:
                    return SoccerTeamDetailView().toAnyView()
                    //return EmptyView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Darts:
            switch page {
            case .Country:
                return DartsCountryView().toAnyView()
            case .Leagues:
                return DartsLeagueView().toAnyView()
            case .LeaguesDetail:
                return EmptyView().toAnyView()
            case .Event:
                return EmptyView().toAnyView()
            case .Team:
                return EmptyView().toAnyView()
            case .TeamDetail:
                return EmptyView().toAnyView()
            case .EventDetail:
                return EmptyView().toAnyView()
            }
        case .Fighting:
            switch page {
                case .Country:
                    return FightingCountryView().toAnyView()
                case .Leagues:
                    return FightingLeagueView().toAnyView()
                case .LeaguesDetail:
                    return FightingLeagueDetailView().toAnyView()
                case .Event:
                    return EmptyView().toAnyView()
                case .Team:
                    return EmptyView().toAnyView()
                case .TeamDetail:
                    return FightingTeamDetailView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Baseball, .Basketball, .AmericanFootball, .IceHockey, .Golf
            , .Rugby, .Tennis, .Cricket, .Cycling, .AustralianFootball, .Esports
            , .Volleyball, .Netball, .Handball, .Snooker, .FieldHockey, .Athletics
            , .Badminton, .Climbing, .Equestrian, .Gymnastics, .Shooting
            , .ExtremeSports, .TableTennis, .MultiSports, .Watersports
            , .Weightlifting, .Skiing, .Skating, .Wintersports
            , .Lacrosse, .Gambling:
            
            return EmptyView().toAnyView()
        }
    }
}
