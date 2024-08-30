//
//  MotorsportLeaguePageView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI
import QGrid

struct MotorsportLeaguePageView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Environment(\.managedObjectContext) var context
    
    @State var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: leaguesVM.columns) { 
                    ForEach(leaguesVM.models, id: \.idLeague) { leagues in
                        leagues.getItemView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                
                                UIApplication.shared.endEditing()
                                
                                motorsportPageVM.add(by: .Leagues)
                                motorsportPageVM.setCurrent(by: .LeaguesDetail)
                                leaguesVM.setDetail(by: leagues)
                                teamVM.fetch(from: leagues)
                                
                                scheduleVM.fetch(from: leagues, for: .Next, from: context) { success in
                                    scheduleVM.fetch(from: leagues, for: .Previous, from: context) { success in
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
