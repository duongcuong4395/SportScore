//
//  ListEventEachRoundOfLeagueAndSeasonView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import Foundation
import SwiftUI

struct ListEventEachRoundOfLeagueAndSeasonView: View {
    var seasonVM: SeasonViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        VStack {
            if seasonVM.leagueSelected != nil && seasonVM.seasonSelected != nil {
                HStack {
                    if eventVM.currentRound > 1 {
                        Text("< Previous")
                            .font(.callout)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    eventVM.listEvent = []
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        eventVM.currentRound -= 1
                                        eventVM.getListEvent(by: seasonVM.leagueSelected?.idLeague ?? ""
                                                             , in: "\(eventVM.currentRound)"
                                                             , of: seasonVM.seasonSelected?.season ?? "") { objs, success in
                                        }
                                    }
                                }
                            }
                    }
                    Text("Round: \(eventVM.currentRound)")
                        .font(.callout.bold())
                    
                    if eventVM.isNextRound == true {
                        Text("Next >")
                            .font(.callout)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    eventVM.listEvent = []
                                    
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        eventVM.currentRound += 1
                                        eventVM.getListEvent(by: seasonVM.leagueSelected?.idLeague ?? ""
                                                             , in: "\(eventVM.currentRound)"
                                                             , of: seasonVM.seasonSelected?.season ?? "") { objs, success in
                                            eventVM.getEventForNextRound()
                                        }
                                    }
                                }
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
                if eventVM.listEvent.count > 0 {
                    ScheduleListItemView(models: eventVM.listEvent)
                        .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                        .onDisappear{
                            eventVM.listEvent = []
                        }
                }
            }
        }
    }
}



