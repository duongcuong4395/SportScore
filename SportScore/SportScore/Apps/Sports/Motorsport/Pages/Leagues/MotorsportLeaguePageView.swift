//
//  MotorsportLeaguePageView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportLeaguePageView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        SportLeaguesView{
            motorsportPageVM.add(.Leagues)
        }
    }
}
