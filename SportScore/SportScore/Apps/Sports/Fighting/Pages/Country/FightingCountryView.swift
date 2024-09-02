//
//  FightingCountryView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingCountryView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        SportCountryView {
            fightingPageVM.add(.Country)
        }
    }
}
