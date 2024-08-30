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
    
    @StateObject var seasonVM = SeasonViewModel()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                leaguesVM.getTrophyView()
                
                scheduleVM.getEventsOfPreviousAndNextDayView()
                
                ListTeamView
                
                ListSeasonOfLeagueView
                
                RankingByLeagueAndSeasonView
                
                ListEventEachRoundOfLeagueAndSeasonView
                
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
            MotorsportTeamView()
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
                //SeasonForLeagueView(league: league)
                MotorsportSeasonForLeagueView(league: league)
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
    
    var ListEventEachRoundOfLeagueAndSeasonView: some View {
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
                    MotorsportEventView()
                        .onDisappear{
                            eventVM.listEvent = []
                        }
                }
            }
        }
    }
    
}

struct MotorsportSeasonForLeagueView: View {
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
                                    
                                    
                                    if let seasonSelected = seasonVM.seasonSelected {
                                        if season.season == seasonSelected.season {
                                            return
                                        }
                                    }
                                    
                                    seasonVM.resetModelRanks()
                                    seasonVM.resetShowRank()
                                    seasonVM.resetSeasonSelected()
                                    seasonVM.setLeagueSelected(by: league)
                                    seasonVM.setSeasonSelected(by: season)
                                    seasonVM.getTableRank()
                                    eventVM.listEvent = []
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                                        
                                        eventVM.currentRound = 1
                                        
                                        eventVM.currentLeagueID = league.idLeague ?? ""
                                        eventVM.currentSeason = seasonVM.seasonSelected?.season ?? ""
                                        eventVM.getListEvent(by: eventVM.currentLeagueID
                                                             , in: "\(eventVM.currentRound)"
                                                             , of: eventVM.currentSeason) { objs, success in
                                            
                                            eventVM.getEventForNextRound()
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            /*
            if seasonVM.leagueSelected != nil && seasonVM.seasonSelected != nil  {
                HStack {
                    Text("Ranks:")
                        .font(.callout.bold())
                    Spacer()
                }
                LookuptableLeagueView()
                
            }
            */
            
        }
        
        
        .onAppear {
            print("==== onAppear.SeasonForLeagueView", league.idLeague ?? "", league.leagueName ?? "")
            seasonVM.getAllSeason(by: league)
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

