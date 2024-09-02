//
//  MotorsportCountryView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI
import QGrid

struct MotorsportCountryView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    var body: some View {
        SportCountryView {
            motorsportPageVM.add(.Country)
        }
    }
}

