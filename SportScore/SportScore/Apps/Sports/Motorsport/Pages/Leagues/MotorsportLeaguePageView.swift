//
//  MotorsportLeaguePageView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI
import QGrid

struct MotorsportLeaguePageView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        SportLeaguesView{
            motorsportPageVM.setCurrent(by: .LeaguesDetail)
            motorsportPageVM.add(by: .Leagues)
        }
    }
}
