//
//  MotorsportView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @StateObject var motorsportPageVM = MotorsportPageViewModel()
    
    var body: some View {
        SportView(pages: motorsportPageVM.pages, pageSelected: motorsportPageVM.pageSelected)
            .environmentObject(motorsportPageVM)
            .onAppear{
                if countryVM.modelDetail != nil, leaguesVM.modelDetail == nil {
                    motorsportPageVM.add(.Country)
                }
            }
    }
}

