//
//  MotorsportEventDetailView.swift
//  SportScore
//
//  Created by pc on 26/08/2024.
//

import SwiftUI

struct MotorsportEventDetailView: View {
    var body: some View {
        EventDetailView()
    }
}

import Kingfisher
import SwiftfulLoadingIndicators

struct ScheduleMotorsportModelItemView: View {
    var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        SportSingleEventItemView(model: model, optionView: optionView)
    }
}
