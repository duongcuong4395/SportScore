//
//  SoccerCountryView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI
import QGrid

struct SoccerCountryView: View {
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    
    var body: some View {
        SportCountryView {
            withAnimation {
                soccerPageVM.add(.Country)
            }
        }
    }
}
