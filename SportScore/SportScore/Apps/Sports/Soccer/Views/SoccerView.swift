//
//  SoccerView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerView: View {
    @StateObject var soccerPageVM = SoccerPageViewModel()
    
    var body: some View {
        SportView(pages: soccerPageVM.pages, pageSelected: soccerPageVM.pageSelected)
            .environmentObject(soccerPageVM)
    }
}

