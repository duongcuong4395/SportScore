//
//  MotorsportLeagueItemMenuView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportLeagueItemMenuView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing()
                    motorsportPageVM.removeFrom(.Leagues)
                }
            }))
            .scaleEffect(0.85)
    }
}
