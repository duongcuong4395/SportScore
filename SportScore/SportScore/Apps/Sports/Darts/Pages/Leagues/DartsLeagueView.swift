//
//  DartsLeagueView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsLeagueView: View {
    @EnvironmentObject var dartsPageVM: DartsPageViewModel
    
    var body: some View {
        SportLeaguesView{
            dartsPageVM.add(by: .Leagues)
        }
    }
}
