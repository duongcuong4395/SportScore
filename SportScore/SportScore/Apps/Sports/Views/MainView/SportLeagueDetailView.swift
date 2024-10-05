//
//  SportLeagueDetailView.swift
//  SportScore
//
//  Created by Macbook on 1/10/24.
//

import Foundation
import SwiftUI

struct SportLeagueDetailView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        LeaguesDetailGenView(sportPageVM: sportsPageVM)
    }
}

struct LeaguesDetailGenView<sportPageVM: SportPageViewModel>: View, LeaguesDetailDelegate {
    var sportPageVM: sportPageVM
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @StateObject var seasonVM = SeasonViewModel()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                leaguesVM.getTrophyView()
                    .padding(.horizontal, 5)
                
                
                if let league = leaguesVM.modelDetail {
                    SocialView(facebook: league.facebook
                               , twitter: league.twitter
                               , instagram: league.instagram
                               , youtube: league.youtube
                               , website: league.website)
                }
                scheduleVM.getEventsOfPreviousAndNextDayView()
                    .frame(height: UIScreen.main.bounds.height / 1.5)
                getListTeamView {
                    self.sportPageVM.add(.Team)
                }
                .padding(.horizontal, 5)
                
                getListSeasonOfLeagueView()
                    .padding(.horizontal, 5)
                
                getRankingByLeagueAndSeasonView()
                    .padding(.horizontal, 5)
                getListEventEachRoundOfLeagueAndSeasonView()
                    .padding(.horizontal, 5)
                getListEventSpecificView()
                    .padding(.horizontal, 5)
                
                getLeagueDetailInforView()
                    .padding(.horizontal, 5)
                
                if let league = leaguesVM.modelDetail {
                    LeaguesAdsView(league: league)
                        //.padding(.horizontal, 5)
                }
            }
        }
        .environmentObject(seasonVM)
        //.padding(.horizontal, 5)
    }
}


protocol LeaguesDetailDelegate {
    
    var seasonVM: SeasonViewModel { get }
    var eventVM: EventViewModel { get }
    var leaguesVM: LeaguesViewModel { get }
}

extension LeaguesDetailDelegate {
    
    @ViewBuilder
    func getRankingByLeagueAndSeasonView() -> some View {
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
    
    @ViewBuilder
    func getListEventEachRoundOfLeagueAndSeasonView() -> some View {
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
    
    @ViewBuilder
    func getListEventSpecificView() -> some View {
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
    
    @ViewBuilder
    func getLeagueDetailInforView() -> some View {
        VStack {
            HStack {
                Text("Description:")
                    .font(.callout.bold())
                Spacer()
            }
            Text(leaguesVM.modelDetail?.descriptionEN ?? "")
                .font(.caption)
                .lineLimit(nil)
                .frame(alignment: .leading)
        }
        //.padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func getListSeasonOfLeagueView() -> some View {
        VStack {
            if let league = leaguesVM.modelDetail {
                HStack {
                    Text("Seasons:")
                        .font(.callout.bold())
                        
                    Spacer()
                }
                SeasonForLeagueView(league: league)
            }
        }
    }
    
    @ViewBuilder
    func getListTeamView(with action: @escaping () -> Void) -> some View {
        VStack {
            HStack {
                Text("Teams")
                    .font(.callout.bold())
                Spacer()
            }
            SportListTeamView {
                action()
            }
            .frame(height: UIScreen.main.bounds.height / 2)
        }
    }
}
