//
//  FightingLeagueDetailView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingLeagueDetailView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        LeaguesDetailGenView(sportPageVM: fightingPageVM)
    }
}

/*
extension FightingLeagueDetailView {
    var ListTeamView: some View {
        VStack {
            HStack {
                Text("Teams")
                    .font(.callout.bold())
                Spacer()
            }
            SportListTeamView {
                fightingPageVM.add(.Team)
            }
            .frame(height: UIScreen.main.bounds.height / 2)
        }
    }
    
    var ListSeasonOfLeagueView: some View {
        VStack {
            if let league = leagueVM.modelDetail {
                HStack {
                    Text("Seasons:")
                        .font(.callout.bold())
                        
                    Spacer()
                }
                SeasonForLeagueView(league: league)
            }
        }
    }
    
    var RankingByLeagueAndSeasonView: some View {
        VStack {
            if seasonVM.leagueSelected != nil && seasonVM.seasonSelected != nil  {
                if seasonVM.modelsRank.count > 0 {
                    HStack {
                        Text("Ranks")
                            .font(.callout.bold())
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                    
                    LookuptableLeagueView()
                        .padding(.bottom, 10)
                        .frame(height: UIScreen.main.bounds.height / 2.5)
                }
                
            }
        }
    }
}
*/

struct ListEventSpecificView: View {
    
    var seasonVM: SeasonViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        VStack {
            VStack {
                if seasonVM.leagueSelected != nil && seasonVM.seasonSelected != nil {
                    if eventVM.listEventInSpecific.count > 0 {
                        HStack {
                            Text("Event Specific")
                                .font(.callout.bold())
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        ScheduleListItemView(models: eventVM.listEventInSpecific)
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                            .onDisappear{
                                eventVM.listEventInSpecific = []
                            }
                    }
                }
            }
        }
    }
}
