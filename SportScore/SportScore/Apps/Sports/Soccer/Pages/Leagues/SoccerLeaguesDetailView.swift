//
//  SoccerLeaguesDetailView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerLeaguesDetailView: View {
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
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
                    .frame(height: UIScreen.main.bounds.height / 1.5)
                
                ListTeamView
                
                ListSeasonOfLeagueView
                
                RankingByLeagueAndSeasonView
                
                ListEventEachRoundOfLeagueAndSeasonView(seasonVM: seasonVM)
                
                ListEventSpecificView(seasonVM: seasonVM)
                
                SoccerLeagueDetailInforView()
                
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
    
    var ListTeamView: some View {
        VStack {
            HStack {
                Text("Teams")
                    .font(.callout.bold())
                Spacer()
            }
            SportListTeamView {
                soccerPageVM.add(by: .Team)
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


struct SoccerLeaguesSocisalView: View {
    @Environment(\.openURL) var openURL
    var league : LeaguesModel
    
    var body: some View {
        VStack(spacing: 30) {
            Button (action: {
                openURL(URL(string: "https://\(league.youtube ?? "")")!)
            }, label: {
                Image("youtube")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(league.twitter ?? "")")!)
            }, label: {
                Image("twitter")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            if let instagram = league.instagram {
                if instagram != "" {
                    Button (action: {
                        openURL(URL(string: "https://\(league.instagram ?? "")")!)
                    }, label: {
                        Image("instagram")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                    })
                }
            }
            
            Button (action: {
                openURL(URL(string: "https://\(league.facebook ?? "")")!)
            }, label: {
                Image("facebook")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            
            Button (action: {
                openURL(URL(string: "https://\(league.website ?? "")")!)
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

import Kingfisher
import SwiftfulLoadingIndicators

struct SoccerLeagueDetailInforView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    var body: some View {
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
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}




struct LookuptableLeagueView: View {
    @EnvironmentObject var seasonVM: SeasonViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showRanks: [Bool] = []
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(seasonVM.modelsRank.enumerated()), id: \.element.id) { index, rank in
                        HStack {
                            ArrowShape()
                                .fill(.green)
                                .frame(width: 40, height: 30)
                                .overlay {
                                    Text(rank.intRank ?? "")
                                        .font(.callout.bold())
                                        .foregroundStyle(.white)
                                }
                                
                            
                            KFImage(URL(string: rank.badge ?? ""))
                                .placeholder { progress in
                                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                .onTapGesture {
                                    withAnimation {
                                        UIApplication.shared.endEditing()
                                        
                                        guard let team = teamVM.getTeam(by: rank.idTeam ?? "") else { return }
                                        
                                        soccerPageVM.add(by: .Team)
                                        
                                        teamVM.setDetail(by: team)
                                        
                                        playerVM.resetModels()
                                        playerVM.fetch(by: team)
                                        
                                        scheduleVM.resetModels()
                                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                                        scheduleVM.getLastEvents(by: team.idTeam ?? "0")
                                        
                                        equipmentVM.fetch(from: team) {}
                                        
                                    }
                                }
                            VStack {
                                HStack {
                                    Text(rank.teamName ?? "")
                                        .font(.caption.bold())
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Win: \(rank.winNumber ?? "")   Loss: \(rank.lossNumber ?? "")   Draw: \(rank.drawNumber ?? "")")
                                        .font(.caption)
                                    Spacer()
                                    Text("Points: \(rank.pointsNumber ?? "")")
                                        .font(.caption)
                                }
                            }
                            Spacer()
                            
                        }
                        .sequentiallyAnimating(isVisible: seasonVM.showRanks.indices.contains(index) ?
                                               $seasonVM.showRanks[index] : .constant(false), delay: Double(index) * 0.2, direction: .leftToRight)
                        .onAppear{
                            // .easeInOut(duration: 0.5)
                            //withAnimation {}
                            
                            seasonVM.showRanks[index] = true
                        }
                    }
                }
            }
        }
        .onChange(of: seasonVM.modelsRank) { vl, nvl in
            print("$seasonVM.showRanks:", seasonVM.showRanks.count, seasonVM.modelsRank.count)
            
            // Chỉ khởi tạo showCars nếu nó chưa được khởi tạo hoặc có kích thước không khớp
            if seasonVM.showRanks.count != seasonVM.modelsRank.count {
                
                self.seasonVM.showRanks = Array(repeating: false, count: seasonVM.modelsRank.count)
                /*
                if seasonVM.showRanks.count > 0 {
                    for index in seasonVM.modelsRank.indices {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                seasonVM.showRanks[index] = true
                            }
                        }
                    }
                }
                */
                
           }
        }
        .onAppear{
            print("$seasonVM.showRanks:", seasonVM.showRanks.count, seasonVM.modelsRank.count)
            if seasonVM.showRanks.count != seasonVM.modelsRank.count {
                
                self.seasonVM.showRanks = Array(repeating: false, count: seasonVM.modelsRank.count)
            }
        }
        .onDisappear{
            seasonVM.resetModelRanks()
            seasonVM.resetSeasonSelected()
        }
    }
        
}


struct LeaguesAdsView: View {
    var league: LeaguesModel
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            KFImage(URL(string: league.banner ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: 100)
                //.padding()
            
            LazyVGrid(columns: column) {
                KFImage(URL(string: league.fanart1 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart2 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart3 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
                KFImage(URL(string: league.fanart4 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
            }
            //.padding()
            
            KFImage(URL(string: league.poster ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: 500)
        }
        
    }
}
