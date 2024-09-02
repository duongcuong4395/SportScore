//
//  SoccerView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @StateObject var soccerPageVM = SoccerPageViewModel()
    
    var body: some View {
        SportView(pages: soccerPageVM.pages, pageSelected: soccerPageVM.pageSelected)
            .environmentObject(soccerPageVM)
            .onAppear{
                if countryVM.modelDetail != nil, leaguesVM.modelDetail == nil {
                    soccerPageVM.add(.Country)
                }
            }
    }
}

