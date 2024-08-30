//
//  MotorsportLeagueItemMenuView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportLeagueItemMenuView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        LeaguesItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    motorsportPageVM.removeFrom(.Leagues)
                    motorsportPageVM.setCurrent(by: .Leagues)
                    appVM.loading = false
                }
            }))
            .scaleEffect(0.85)
    }
}
