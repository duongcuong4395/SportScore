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
