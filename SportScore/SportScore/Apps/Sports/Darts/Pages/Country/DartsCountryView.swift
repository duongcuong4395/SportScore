//
//  DartsCountryView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsCountryView: View {
    @EnvironmentObject var dartsPageVM: DartsPageViewModel
    
    var body: some View {
        SportCountryView {
            dartsPageVM.add(by: .Country)
        }
    }
}


