//
//  SeasonForLeagueView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import Foundation
import SwiftUI



struct SeasonForLeagueView: View {
    @EnvironmentObject var seasonVM: SeasonViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @State var league: LeaguesModel
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(seasonVM.models.sorted{ $0.season ?? "" > $1.season ?? "" }, id: \.season) { season in
                        Text("\(season.season ?? "")")
                            .font(.callout.bold())
                            .padding(5)
                            .background(.thinMaterial.opacity(season.season ?? "" == seasonVM.seasonSelected?.season ?? ""  ? 1 : 0)
                                        , in: RoundedRectangle(cornerRadius: 25))
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    seasonVM.resetModelRanks()
                                    seasonVM.resetShowRank()
                                    seasonVM.resetSeasonSelected()
                                    seasonVM.setLeagueSelected(by: league)
                                    seasonVM.setSeasonSelected(by: season)
                                    seasonVM.getTableRank()
                                    eventVM.listEvent = []
                                    eventVM.listEventInSpecific = []
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                                        eventVM.currentRound = 1
                                        
                                        eventVM.currentLeagueID = league.idLeague ?? ""
                                        eventVM.currentSeason = seasonVM.seasonSelected?.season ?? ""
                                        eventVM.getListEvent(by: eventVM.currentLeagueID
                                                             , in: "\(eventVM.currentRound)"
                                                             , of: eventVM.currentSeason) { objs, success in
                                            
                                            eventVM.getEventForNextRound()
                                        }
                                        
                                        eventVM.getEventsInSpecific(by: eventVM.currentLeagueID
                                                                    , of: eventVM.currentSeason) { objs, success in
                                            // do something
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                    }
                }
            }
        }
        .onAppear {
            seasonVM.getAllSeason(by: league)
        }
    }
}
