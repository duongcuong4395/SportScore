//
//  SoccerLeaguesPageView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI
import QGrid
import SkeletonUI

struct SoccerLeaguesView: View {
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    var body: some View {
        SportLeaguesView{
            soccerPageVM.add(.Leagues)
        }
    }
}
