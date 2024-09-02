//
//  TeamView.swift
//  SportScore
//
//  Created by pc on 11/08/2024.
//

import Foundation
import SwiftUI
import QGrid

struct TeamsView: View {
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    
    
    var body: some View {
        QGrid(teamVM.models, columns: 3
              , vPadding: 5, hPadding: 5) { team in
            team.getOptionView(with: getOptionView)
                .padding(0)
                .onTapGesture {
                    
                    withAnimation {
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                        teamVM.setDetail(by: team)
                        
                        //appVM.switchPage(to: .Team)
                        playerVM.resetModels()
                        playerVM.fetch(by: team)
                        scheduleVM.resetModels()
                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                        equipmentVM.fetch(from: team) {}
                        //appVM.switchPage(to: .Player)
                        appVM.switchPage(to: .TeamDetail)
                        
                    }
                }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}


struct TeamDetailMenuView: View {
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
    //@EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
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
                    
                    ForEach (Array(teamVM.models.enumerated()), id: \.element.id) { index, team in
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
