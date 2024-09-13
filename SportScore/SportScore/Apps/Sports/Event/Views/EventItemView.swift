//
//  EventItemView.swift
//  SportScore
//
//  Created by pc on 03/09/2024.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct Sport2vs2EventItemView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    
    
    @State var homeTeam: TeamModel = TeamModel()
    @State var awayTeam: TeamModel = TeamModel()
    
    @State var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: model.timestamp, to: "dd/MM") ?? "")
                        .font(.caption2.bold())
                        
                    Text(model.roundNumber ?? "")
                        .font(.caption2.bold())
                    Text(AppUtility.formatDate(from: model.timestamp, to: "hh:mm") ?? "")
                        .font(.caption2.bold())
                }
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                optionView
            }
            .padding(.horizontal, 50)
            .padding(.trailing, 20)
            
            HStack {
                // MARK: - Home Team
                HStack {
                    Text(model.homeTeamName ?? "")
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width/2 - 50.0)
                        .background {
                            ArrowShape()
                                //.fill(.green)
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.white.opacity(0.1), .black, .black, .black]), startPoint: .leading, endPoint: .trailing))
                                .frame(width: UIScreen.main.bounds.width/2 - 50.0, height: 30)
                                .overlay {
                                    HStack {
                                        KFImage(URL(string: model.homeTeamBadge ?? ""))
                                            .placeholder { progress in
                                                
                                                LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .offset(y: -25)
                                            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                        Spacer()
                                    }
                                }
                        }
                
                    
                }
                .slideInEffect(direction: .leftToRight)
                .onTapGesture {
                    withAnimation {
                        guard let team = teamVM.getTeam(by: model.homeTeamName ?? "") else {
                            teamVM.getTeamDetail(by: model.homeTeamName ?? "") { team in
                                guard let team = team else { return }
                                selectTeam(from: team)
                            }
                            return
                        }
                        selectTeam(from: team)
                    }
                }
                
                Spacer()
                
                // MARK: - Score
                HStack {
                    if ((model.homeScore?.isEmpty) == nil) || model.homeScore == "" {
                        Text("VS")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            
                    } else {
                        Text("\(model.homeScore ?? "") - \(model.awayScore ?? "")")
                            .font(.callout)
                            .font(.system(size: 14, weight: .bold, design: .default))
                    }
                }
                .frame(width: 70)
                
                Spacer()
                
                // MARK: - Away team
                HStack {
                    Text(model.awayTeamName ?? "")
                        .font(.caption)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(width: UIScreen.main.bounds.width/2 - 50.0)
                        .background {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black, .black, .black, .white.opacity(0.1)]), startPoint: .trailing, endPoint: .leading))
                                .rotation3DEffect(Angle(degrees: 180), axis: (0, 1, 0))
                                .frame(width: UIScreen.main.bounds.width/2 - 50.0, height: 30) // width: 40,
                                .overlay {
                                    HStack {
                                        Spacer()
                                        KFImage(URL(string: model.awayTeamBadge ?? ""))
                                            .placeholder { progress in
                                                LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                            }
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .offset(y: -25)
                                            .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                    }
                                }
                        }
                }
                .slideInEffect(direction: .rightToLeft)
                .onTapGesture {
                    withAnimation {
                        guard let team = teamVM.getTeam(by: model.awayTeamName ?? "") else {
                            teamVM.getTeamDetail(by: model.awayTeamName ?? "") { team in
                                guard let team = team else { return }
                                selectTeam(from: team)
                            }
                            return
                        }
                        
                        selectTeam(from: team)
                    }
                }
            }
            .padding(0)
            .padding(.vertical, 5)
        }
    }
    
    func selectTeam(from team: TeamModel) {
        teamVM.setDetail(by: team)
        playerVM.resetModels()
        playerVM.fetch(by: team)
        scheduleVM.resetModels()
        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
        equipmentVM.fetch(from: team) {}
        sportsPageVM.add(.Team)
        scheduleVM.modelsForLastEvents = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            scheduleVM.getLastEvents(by: team.idTeam ?? "0")
        }
    }
}

struct SportSingleEventItemView: View {
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        VStack {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: model.timestamp, to: "dd/MM") ?? "")
                    Text(model.roundNumber ?? "")
                    Text(AppUtility.formatDate(from: model.timestamp, to: "hh:mm") ?? "")
                }
                .font(.caption2)
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                optionView
            }
            .padding(.leading, 40)
            .padding(.trailing, 10)
            
            
            HStack {
                // MARK: - Main Match Infor
                Text(model.eventName ?? "")
                    .font(.caption.bold())
                    .lineLimit(2)
                    .onTapGesture {
                        print("ScheduleMoto:")
                    }
                Spacer()
            }
            .padding(5)
            .padding(.vertical, 5)
            .padding(.leading, 20)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.trailing, 10)
            .padding(.leading, 20)
        }
        .overlay {
            HStack {
                KFImage(URL(string: sportTypeVM.selected.getImageUrl()))
                    .placeholder({ progress in
                        LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                    })
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .shadow(color: Color.yellow, radius: 3, x: 0, y: 0)
                    .padding(.leading, 5)
                    .offset(y: -10)
                    .onTapGesture {
                        eventVM.fetch(by: model.idEvent ?? "") { players in
                            if players.count > 0 {
                                scheduleVM.setModelDetail(by: model)
                                sportsPageVM.add(.Event)
                            }
                        }
                    }
                Spacer()
            }
        }
        .background{
            KFImage(URL(string: model.banner ?? ""))
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            
        }
    }
}
