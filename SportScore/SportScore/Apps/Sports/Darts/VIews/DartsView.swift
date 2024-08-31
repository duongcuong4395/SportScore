//
//  DartsView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsView: View {
    @StateObject var dartsPageVM = DartsPageViewModel()
    
    var body: some View {
        SportView(pages: dartsPageVM.pages, pageSelected: dartsPageVM.pageSelected)
            .environmentObject(dartsPageVM)
    }
}

