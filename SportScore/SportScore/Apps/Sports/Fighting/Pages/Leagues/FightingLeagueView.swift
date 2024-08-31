//
//  FightingLeagueView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingLeagueView: View {
    @EnvironmentObject var fightingPageVM: FightingPageViewModel
    
    var body: some View {
        SportLeaguesView{
            fightingPageVM.add(by: .Leagues)
        }
    }
}
