//
//  DartsLeagueItemMenuView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsLeagueItemMenuView: View {
    @EnvironmentObject var dartsPageVM: DartsPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing()
                    dartsPageVM.removeFrom(.Leagues)
                }
            }))
            .scaleEffect(0.85)
    }
}
