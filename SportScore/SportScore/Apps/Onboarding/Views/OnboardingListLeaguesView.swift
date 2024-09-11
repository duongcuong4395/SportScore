//
//  OnboardingListLeaguesView.swift
//  SportScore
//
//  Created by pc on 06/09/2024.
//

import SwiftUI

struct OnboardingListLeaguesView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leagueVM: LeaguesViewModel
    @State var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, content: {
                    ForEach(leagueVM.models, id: \.idLeague) { league in
                        league.getItemView { EmptyView() }
                            .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                    }
                })
            }
        }
    }
}

