//
//  SportListTeamView.swift
//  SportScore
//
//  Created by Macbook on 1/10/24.
//

import Foundation
import SwiftUI

struct SportTeamItemMenuView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        TeamItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    sportsPageVM.removeFrom(.Team)
                }
            }))
    }
}

struct TeamItemMenuView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    
    var body: some View {
        if let model = teamVM.modelDetail {
            model.getOptionView(with: getOptionView)
                .padding(0)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}

struct SportListTeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showTeam: [Bool] = []
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: teamVM.columns) {
                    switch teamVM.apiState {
                    case .idle:
                        EmptyView()
                    case .loading:
                        ForEach (teamVM.getListEmptyModels(), id: \.id) { team in
                            team.getOptionView(with: {
                                EmptyView()
                            })
                            .padding(0)
                            .redacted(reason: .placeholder)
                            .fadeInEffect(duration: 1, isLoop: true)
                        }
                    case .success(let teams):
                        // teamVM.models
                        ForEach (Array(teams.enumerated()), id: \.element.id) { index, team in
                            team.getOptionView(with: {
                                EmptyView()
                            })
                            .padding(0)
                            .rotateOnAppear(angle: -90, duration: 0.5, axis: .x)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    UIApplication.shared.endEditing()
                                    action()
                                    teamVM.setDetail(by: team)
                                    playerVM.resetModels()
                                    playerVM.fetch(by: team)
                                    scheduleVM.resetModels()
                                    scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                                    scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                                    
                                    equipmentVM.fetch(from: team) {}
                                    
                                    scheduleVM.modelsForLastEvents = []
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        scheduleVM.getLastEvents(by: team.idTeam ?? "0")
                                    }
                                }
                            }
                            
                        }
                    case .failure(let error):
                        EmptyView()
                    }
                }
            }
            
        }
        .onChange(of: teamVM.models) { vl, nvl in
            if showTeam.count != teamVM.models.count {
              self.showTeam = Array(repeating: false, count: teamVM.models.count)
              
              for index in teamVM.models.indices {
                  DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                      withAnimation(.easeInOut(duration: 0.5)) {
                          showTeam[index] = true
                      }
                  }
              }
            }
        }
    }
}
