//
//  RugbyEventItemView.swift
//  SportScore
//
//  Created by pc on 02/09/2024.
//
import SwiftUI

struct RugbyEventItemView: View {
    
    var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        Sport2vs2EventItemView(model: model, optionView: optionView)
    }
}
