//
//  FightingLeagueItemMenuView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingLeagueItemMenuView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing()
                    fightingPageVM.removeFrom(.Leagues)
                }
            }))
            .scaleEffect(0.85)
    }
}

