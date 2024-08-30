//
//  SoccerTeamItemMenuView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerTeamItemMenuView: View {
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    var body: some View {
        TeamItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    //soccerPageVM.removePagesFrom(.Team)
                    //soccerPageVM.setCurrentPage(by: .LeaguesDetail)
                    
                    soccerPageVM.removeFrom(.Team)
                    soccerPageVM.setCurrent(by: .LeaguesDetail)
                }
            }))
    }
}
