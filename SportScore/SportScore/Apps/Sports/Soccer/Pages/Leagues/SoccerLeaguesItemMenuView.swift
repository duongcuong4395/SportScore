//
//  SoccerLeaguesItemMenuView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerLeaguesItemMenuView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing()
                    soccerPageVM.removeFrom(.Leagues)
                }
            }))
            .scaleEffect(0.85)
    }
}
