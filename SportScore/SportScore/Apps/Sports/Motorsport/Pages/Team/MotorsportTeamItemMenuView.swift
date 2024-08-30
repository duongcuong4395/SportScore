//
//  MotorsportTeamItemMenuView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI

struct MotorsportTeamItemMenuView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        TeamItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    motorsportPageVM.removeFrom(.Team)
                    motorsportPageVM.setCurrent(by: .LeaguesDetail)
                }
            }))
    }
}
