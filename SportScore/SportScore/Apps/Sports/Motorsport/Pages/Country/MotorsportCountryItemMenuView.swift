//
//  MotorsportCountryItemMenuView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportCountryItemMenuView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    var body: some View {
        CountryItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    motorsportPageVM.removeFrom(.Country)
                    UIApplication.shared.endEditing()
                }
            }))
            .scaleEffect(0.85)
    }
}
