//
//  MotorsportLeagueDetailView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct MotorsportLeagueDetailView: View {
    @EnvironmentObject var leagueVM: LeaguesViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    
    
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

extension MotorsportLeagueDetailView {
    var ListTeamView: some View {
        VStack {
            HStack {
                Text("Teams")
                    .font(.callout.bold())
                Spacer()
            }
            SportListTeamView {
                motorsportPageVM.add(by: .Team)
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
                //MotorsportSeasonForLeagueView(league: league)
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

struct MotorsportLeagueDetailInforView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Description:")
                    .font(.callout.bold())
                Spacer()
            }
            Text(leaguesVM.modelDetail?.descriptionEN ?? "")
                .lineLimit(nil)
                .frame(alignment: .leading)
            
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}

