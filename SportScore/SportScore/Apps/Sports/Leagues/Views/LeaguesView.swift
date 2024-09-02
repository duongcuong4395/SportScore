//
//  LeaguesView.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import SwiftUI
import QGrid



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


struct SportLeagueDetailView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        LeaguesDetailGenView(sportPageVM: sportsPageVM)
    }
}


struct SportListLeagueView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        SportLeaguesView{
            sportsPageVM.add(.Leagues)
        }
    }
}

struct LeaguesView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @Namespace var aniamtion
    
    var body: some View {
        QGrid(leaguesVM.models, columns: 3
              , vPadding: 5, hPadding: 5) { leagues in
            leagues.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(leagues.leagueName ?? "")", in: aniamtion)
                .padding(0)
                .onTapGesture {
                    appVM.loading = true
                    withAnimation(.spring()) {
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                        leaguesVM.setDetail(by: leagues)
                        //teamVM.resetModels()
                        teamVM.fetch(from: leagues)
                        
                        scheduleVM.fetch(from: leagues, for: .Next, from: context) { success in
                            scheduleVM.fetch(from: leagues, for: .Previous, from: context) { success in
                                //appVM.switchPage(to: .LeagueDetail)
                                //appVM.loading = false
                            }
                        }
                        
                        
                        
                        
                    }
                }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}


struct LeaguesDetailView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = leaguesVM.modelDetail {
            model.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        
    }
}



struct LeaguesItemMenuView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = leaguesVM.modelDetail {
            model.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        
    }
}



struct SportLeaguesView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Environment(\.managedObjectContext) var context
    
    var action: () -> Void
    
    var body: some View {
        switch leaguesVM.requestAPIState {
        case .Idle:
            EmptyView()
        case .Loading:
            QGrid(leaguesVM.getListEmptyModels(), columns: 3
                  , vPadding: 5, hPadding: 5) { leagues in
                leagues.getItemView(with: {
                    EmptyView()
                })
                .redacted(reason: .placeholder)
                
            }
        case .Success:
            QGrid(leaguesVM.models, columns: 3
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
        case .Fail:
            EmptyView()
        }
        
    }
}
