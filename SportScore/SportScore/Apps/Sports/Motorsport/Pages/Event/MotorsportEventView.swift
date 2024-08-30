//
//  MotorsportEventView.swift
//  SportScore
//
//  Created by pc on 26/08/2024.
//

import SwiftUI


struct MotorsportEventView: View {
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

