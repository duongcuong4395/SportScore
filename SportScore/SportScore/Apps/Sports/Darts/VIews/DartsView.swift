//
//  DartsView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsView: View {
    @StateObject var dartsPageVM = DartsPageViewModel()
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    var body: some View {
        VStack {
            HStack {
                ForEach(dartsPageVM.pages, id: \.self) { page in
                    sportTypeVM.selected.getItemMenuView(by: page)
                }
            }
            
            ZStack {
                sportTypeVM.selected.getView(by: dartsPageVM.pageSelected)
            }
        }
        .environmentObject(dartsPageVM)
    }
}

