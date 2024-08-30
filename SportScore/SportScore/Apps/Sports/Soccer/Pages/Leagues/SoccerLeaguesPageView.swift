//
//  SoccerLeaguesPageView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI
import QGrid
import SkeletonUI

struct SoccerLeaguesView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Environment(\.managedObjectContext) var context
    
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
                        //appVM.loading = true
                        withAnimation(.spring()) {
                            UIApplication.shared.endEditing() // Dismiss the keyboard
                            //soccerPageVM.setCurrentPage(by: .LeaguesDetail)
                            //soccerPageVM.addPage(by: .Leagues)
                            soccerPageVM.setCurrent(by: .LeaguesDetail)
                            soccerPageVM.add(by: .Leagues)
                            leaguesVM.setDetail(by: leagues)
                            teamVM.fetch(from: leagues)
                            
                            scheduleVM.fetch(from: leagues, for: .Next, from: context) { success in
                                scheduleVM.fetch(from: leagues, for: .Previous, from: context) { success in
                                    
                                    //appVM.loading = false
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
