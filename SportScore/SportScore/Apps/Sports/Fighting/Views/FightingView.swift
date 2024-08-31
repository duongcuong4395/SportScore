//
//  FightingView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct FightingView: View {
    @StateObject var fightingPageVM = FightingPageViewModel()
    
    var body: some View {
        SportView(pages: fightingPageVM.pages, pageSelected: fightingPageVM.pageSelected)
            .environmentObject(fightingPageVM)
    }
}
