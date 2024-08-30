//
//  SoccerEventView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI

struct SoccerEventView: View {
    @EnvironmentObject var eventVM: EventViewModel
    var body: some View {
        VStack {
            ScheduleListItemView(models: eventVM.listEvent)
        }
        .onAppear{
            print("eventVM:", eventVM.currentRound, eventVM.currentSeason, eventVM.currentLeagueID)
        }
    }
}

// MARK: - View List event of league into Round by leagueID and round and season

