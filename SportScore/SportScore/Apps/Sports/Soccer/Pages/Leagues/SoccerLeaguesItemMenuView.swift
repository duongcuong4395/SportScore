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
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    //soccerPageVM.removePagesFrom(.Leagues)
                    //soccerPageVM.setCurrentPage(by: .Leagues)
                    soccerPageVM.removeFrom(.Leagues)
                    soccerPageVM.setCurrent(by: .Leagues)
                    //appVM.loading = false
                }
            }))
            .scaleEffect(0.85)
    }
}
