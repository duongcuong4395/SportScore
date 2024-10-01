//
//  SportLeaguesView.swift
//  SportScore
//
//  Created by Macbook on 1/10/24.
//

import Foundation
import SwiftUI
import QGrid

// MARK: League

/// League: Item Menu
struct SportLeagueItemMenuView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing()
                    sportsPageVM.removeFrom(.Leagues)
                }
            }))
            .scaleEffect(0.85)
    }
}

struct LeaguesItemMenuView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = leaguesVM.modelDetail {
            model.getItemView{ EmptyView() }
                .matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
}

/// League: Page View
struct SportListLeagueView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        SportLeaguesView{
            sportsPageVM.add(.Leagues)
        }
    }
}

struct SportLeaguesView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Environment(\.managedObjectContext) var context
    
    var action: () -> Void
    
    var body: some View {
        switch leaguesVM.state {
        case .idle:
            EmptyView()
        case .loading:
            QGrid(leaguesVM.getListEmptyModels(), columns: 3
                  , vPadding: 5, hPadding: 5) { leagues in
                leagues.getItemView(with: {
                    EmptyView()
                })
                .redacted(reason: .placeholder)
                .fadeInEffect(duration: 1, isLoop: true)
            }
        case .success(let leagues):
            QGrid(leagues, columns: 3
                  , vPadding: 5, hPadding: 5) { leagues in
                leagues.getItemView(with: {
                    EmptyView()
                })
                    .padding(0)
                    .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            UIApplication.shared.endEditing()
                            action()
                            leaguesVM.setDetail(by: leagues)
                            teamVM.fetch(from: leagues)
                            
                            scheduleVM.fetch(from: leagues, for: .Next, from: context) { success in
                                scheduleVM.fetch(from: leagues, for: .Previous, from: context) { success in
                                }
                            }
                        }
                    }
            }
        case .failure(_):
            EmptyView()
        }
        
    }
}
