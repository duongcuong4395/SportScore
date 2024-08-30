//
//  LeaguesView.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import SwiftUI
import QGrid

struct LeaguesView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @Namespace var aniamtion
    
    var body: some View {
        QGrid(leaguesVM.models, columns: 3
              , vPadding: 5, hPadding: 5) { leagues in
            leagues.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(leagues.leagueName ?? "")", in: aniamtion)
                .padding(0)
                .onTapGesture {
                    appVM.loading = true
                    withAnimation(.spring()) {
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                        leaguesVM.setDetail(by: leagues)
                        //teamVM.resetModels()
                        teamVM.fetch(from: leagues)
                        
                        scheduleVM.fetch(from: leagues, for: .Next, from: context) { success in
                            scheduleVM.fetch(from: leagues, for: .Previous, from: context) { success in
                                appVM.switchPage(to: .LeagueDetail)
                                appVM.loading = false
                            }
                        }
                        
                        
                        
                        
                    }
                }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}


struct LeaguesDetailView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = leaguesVM.modelDetail {
            model.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        
    }
}



struct LeaguesItemMenuView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = leaguesVM.modelDetail {
            model.getItemView(with: getOptionView)
                .matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        
    }
}
