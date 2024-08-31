//
//  FightingTeamItemMenuView.swift
//  SportScore
//
//  Created by pc on 31/08/2024.
//

import SwiftUI

struct FightingTeamItemMenuView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        TeamItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    fightingPageVM.removeFrom(.Team)
                }
            }))
    }
}
