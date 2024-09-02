//
//  MotorsportLeagueDetailView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct MotorsportLeagueDetailView: View, LeaguesDetailDelegate {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    @EnvironmentObject var leagueVM: LeaguesViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    
    @StateObject var seasonVM = SeasonViewModel()
    
    var body: some View {
        LeaguesDetailGenView(sportPageVM: motorsportPageVM)
    }
}


