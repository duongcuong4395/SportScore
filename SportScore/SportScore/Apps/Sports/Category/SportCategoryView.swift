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

extension SportType {
    
    func getItemMenuView(by page: SportPage) -> AnyView {
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
            
        }
    }
    
    func getView(by page: SportPage) -> AnyView {
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
