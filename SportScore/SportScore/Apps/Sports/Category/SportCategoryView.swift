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
}

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
                    return EmptyView().toAnyView()
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
                    return EmptyView().toAnyView()
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
        case .Fighting
            , .Baseball, .Basketball, .AmericanFootball, .IceHockey, .Golf
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
                    return MotorsportTeamView().toAnyView()
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
                    return SoccerTeamView().toAnyView()
                case .Event:
                    return SoccerScheduleView().toAnyView()
                case .LeaguesDetail:
                    return SoccerLeaguesDetailView().toAnyView()
                case .TeamDetail:
                    return SoccerTeamDetailView().toAnyView()
                case .EventDetail:
                    return EmptyView().toAnyView()
            }
        case .Darts:
            switch page {
            case .Country:
                return DartsCountryView().toAnyView()
            case .Leagues:
                return EmptyView().toAnyView()
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
        case .Fighting
            , .Baseball, .Basketball, .AmericanFootball, .IceHockey, .Golf
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
