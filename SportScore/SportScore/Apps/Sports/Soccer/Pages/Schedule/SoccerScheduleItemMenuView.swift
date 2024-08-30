//
//  SoccerScheduleItemMenuView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerScheduleItemMenuView: View {
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    var body: some View {
        Text("ScheduleItemMenuView")
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    //soccerPageVM.removeFrom(.Schedule)
                }
            }))
    }
}
