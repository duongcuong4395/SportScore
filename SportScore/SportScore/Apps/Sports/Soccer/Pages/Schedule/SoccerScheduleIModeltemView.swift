//
//  SoccerScheduleIModeltemView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct SoccerScheduleIModeltemView: View {
    var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        Sport2vs2EventItemView(model: model, optionView: optionView)
    }
}

