//
//  FightingCountryItemMenuView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingCountryItemMenuView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        CountryItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    fightingPageVM.removeFrom(.Country)
                    UIApplication.shared.endEditing()
                }
            }))
            .scaleEffect(0.85)
    }
}
