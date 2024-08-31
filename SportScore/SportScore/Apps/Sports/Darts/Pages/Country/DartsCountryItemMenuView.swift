//
//  DartsCountryItemMenuView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsCountryItemMenuView: View {
    @EnvironmentObject var dartsPageVM: DartsPageViewModel
    var body: some View {
        CountryItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    dartsPageVM.removeFrom(.Country)
                    UIApplication.shared.endEditing()
                }
            }))
            .scaleEffect(0.85)
    }
}
