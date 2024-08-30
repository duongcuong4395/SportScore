//
//  DartsCountryView.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import SwiftUI

struct DartsCountryView: View {
    @EnvironmentObject var dartsPageVM: DartsPageViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        SportCountryView {
            dartsPageVM.add(by: .Country)
            dartsPageVM.setCurrent(by: .Leagues)
        }
        
        /*
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: countryVM.columns) {
                    ForEach(countryVM.modelsFilter.count > 0 ? countryVM.modelsFilter : countryVM.models, id: \.id) { country in
                        country.getItemView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                UIApplication.shared.endEditing()
                                
                                dartsPageVM.add(by: .Country)
                                dartsPageVM.setCurrent(by: .Leagues)
                                
                                appVM.resetTextSearch()
                                countryVM.resetFilter()
                                countryVM.setDetail(by: country)
                                
                                leaguesVM.resetModels()
                                leaguesVM.fetch(from: country, by: sportTypeVM.selected) {
                                }
                            }
                        }
                    }
                }
            }
        }
        */
    }
}


