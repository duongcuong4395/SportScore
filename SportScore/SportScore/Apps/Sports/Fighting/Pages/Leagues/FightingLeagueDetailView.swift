//
//  FightingLeagueDetailView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingLeagueDetailView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    @EnvironmentObject var leagueVM: LeaguesViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    
    
    @StateObject var seasonVM = SeasonViewModel()
    
    
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                leaguesVM.getTrophyView()
                
                scheduleVM.getEventsOfPreviousAndNextDayView()
                
                ListTeamView
                
                ListSeasonOfLeagueView
                
                RankingByLeagueAndSeasonView
                
                ListEventEachRoundOfLeagueAndSeasonView(seasonVM: seasonVM)
                
                ListEventSpecificView(seasonVM: seasonVM)
                
                MotorsportLeagueDetailInforView()
                
                if let league = leaguesVM.modelDetail {
                    LeaguesAdsView(league: league)
                }
            }
        }
        .overlay(content: {
            HStack {
                Spacer()
                if let league = leagueVM.modelDetail {
                    SoccerLeaguesSocisalView(league: league)
                }
            }
        })
        .environmentObject(seasonVM)
    }
}

extension FightingLeagueDetailView {
    var ListTeamView: some View {
        VStack {
            HStack {
                Text("Teams")
                    .font(.callout.bold())
                Spacer()
            }
            SportListTeamView {
                fightingPageVM.add(by: .Team)
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
