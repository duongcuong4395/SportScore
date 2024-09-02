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

// MARK: - For Item Menu
extension SportType {
    func getMenuItemView(by page: SportPage) -> AnyView {
        switch (self, page) {
        case (.Motorsport, .Country):
            return MotorsportCountryItemMenuView().toAnyView()
        case (.Motorsport, .Leagues):
            return MotorsportLeagueItemMenuView().toAnyView()
        case (.Motorsport, .Event):
            return MotorsportEventItemMenuView().toAnyView()
        case (.Motorsport, .Team):
            return MotorsportTeamItemMenuView().toAnyView()
        
        case (.Soccer, .Country):
            return SoccerCountryItemMenuView().toAnyView()
        case (.Soccer, .Leagues):
            return SoccerLeaguesItemMenuView().toAnyView()
        //case (.Soccer, .Event):
            //return MotorsportEventItemMenuView().toAnyView()
        case (.Soccer, .Team):
            return SoccerTeamItemMenuView().toAnyView()
            
        case (_, _):
            return EmptyView().toAnyView()
        }
    }
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
                    //return MotorsportEventItemMenuView().toAnyView()
                    return EmptyView().toAnyView()
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

extension SportType {
    
    func getItemMenuView2(by page: SportPage) -> AnyView {
        switch page {
            case .Country:
                return SportCountryItemMenuView().toAnyView()
            case .Leagues:
                return SportLeagueItemMenuView().toAnyView()
            case .Event:
                return SportEventItemMenuView().toAnyView()
            case .Team:
                return SportTeamItemMenuView().toAnyView()
            default:
                return EmptyView().toAnyView()
            /*
            case .TeamDetail:
                return EmptyView().toAnyView()
            case .EventDetail:
                return EmptyView().toAnyView()
            case .LeaguesDetail:
                return EmptyView().toAnyView()
             */
        }
    }
    
    func getView2(by page: SportPage) -> AnyView {
        switch page {
            case .Country:
                return SportListCountryView().toAnyView()
            case .Leagues:
                return SportListLeagueView().toAnyView()
            case .Team:
                return EmptyView().toAnyView()
            case .Event:
                return SportEventView().toAnyView()
            case .LeaguesDetail:
                return SportLeagueDetailView().toAnyView()
            case .TeamDetail:
                return SportTeamDetailView().toAnyView()
            case .EventDetail:
                return EventDetailView().toAnyView()
        }
    }
}
