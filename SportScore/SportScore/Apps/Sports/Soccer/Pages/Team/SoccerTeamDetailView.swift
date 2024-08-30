//
//  SoccerTeamDetailView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerTeamDetailView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if scheduleVM.modelsForNext.count > 0 || scheduleVM.modelsForPrevious.count > 0 {
                    HStack {
                        Text("Schedule")
                            .font(.callout.bold())
                        Spacer()
                    }
                    ScheduleView()
                        .frame(height: UIScreen.main.bounds.height / 1.5)
                }
                if scheduleVM.modelsForLastEvents.count > 0 {
                    HStack {
                        Text("Last event:")
                            .font(.callout.bold())
                        Spacer()
                    }
                    
                    ScheduleListItemView(models: scheduleVM.modelsForLastEvents)
                        .onDisappear{
                            scheduleVM.modelsForLastEvents = []
                        }
                }
                
                if playerVM.models.count > 0 {
                    HStack {
                        Text("Players")
                            .font(.callout.bold())
                        Spacer()
                    }
                    PlayerView()
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                
                
                HStack {
                    Text("Equipments")
                        .font(.callout.bold())
                    Spacer()
                }
                EquipmentView()
                
                
                HStack {
                    Text("Trophies:")
                        .font(.callout.bold())
                    Spacer()
                }
                ListTrophyOfTeamView()
                
                HStack {
                    Text("Description:")
                        .font(.callout.bold())
                    Spacer()
                }
                Text(teamVM.modelDetail?.descriptionEN ?? "")
                
                if let team = teamVM.modelDetail {
                    TeamAdsView(team: team)
                }
            }
        }
        .overlay {
            HStack{
                Spacer()
                if let team = teamVM.modelDetail {
                    TeamSocialView(team: team)
                }
                
            }
        }
        
    }
}

struct TeamSocialView: View {
    @Environment(\.openURL) var openURL
    var team: TeamModel
    
    var body: some View {
        VStack(spacing: 30) {
            Button (action: {
                openURL(URL(string: "https://\(team.youtube ?? "")")!)
            }, label: {
                Image("youtube")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(team.twitter ?? "")")!)
            }, label: {
                Image("twitter")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(team.instagram ?? "")")!)
            }, label: {
                Image("instagram")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(team.facebook ?? "")")!)
            }, label: {
                Image("facebook")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(team.website ?? "")")!)
            }, label: {
                Image("website")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
        }.padding(5)
            .background(.thinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        
    }
}

struct ListTrophyOfTeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    var body: some View {
        HStack {
            if let idLeague = teamVM.modelDetail?.idLeague {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.leagueName ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague2 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league2Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague3 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league3Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague4 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league4Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague5 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league5Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague6 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league6Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague7 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league7Name ?? ""))
            }
        }
    }
}


struct SeasonForTaeamView: View {
    @StateObject var seasonVM = SeasonViewModel()
    @State var league: LeaguesModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text(league.leagueName ?? "")
                    .font(.caption.bold())
                    .onTapGesture {
                        print("league: \(league.leagueName ?? "")")
                    }
                /*
                ForEach(seasonVM.models.sorted{ $0.season ?? "" > $1.season ?? "" }, id: \.season) { season in
                    HStack {
                        LookuptableLeagueTeamView(league: league, season: season)
                    }
                    
                }
                */
            }
        }
        
        .onAppear {
            print("seasonVM.getAllSeason: ", league.idLeague ?? "", league.leagueName ?? "")
            seasonVM.getAllSeason(by: league)
        }
    }
}


struct LookuptableLeagueTeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @StateObject var seasonVM = SeasonViewModel()
    @State var league: LeaguesModel
    @State var season: SeasonModel
    
    var body: some View {
        VStack {
            
            ForEach(seasonVM.modelsRank, id: \.idStanding) { rank in
                
                Text(rank.season ?? "")
            }
        }
        .onAppear {
            seasonVM.getTableRank(by: league, and: season, for: teamVM.modelDetail?.teamName ?? "")
        }
    }
}


import Kingfisher
import SwiftfulLoadingIndicators

struct TeamAdsView: View {
    var team: TeamModel
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            KFImage(URL(string: team.logo ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: 100)
                //.padding()
            
            LazyVGrid(columns: column) {
                KFImage(URL(string: team.fanart1 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: team.fanart2 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: team.fanart3 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
                KFImage(URL(string: team.fanart4 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
            }
            //.padding()
            
            KFImage(URL(string: team.banner ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
        }
        
    }
}
