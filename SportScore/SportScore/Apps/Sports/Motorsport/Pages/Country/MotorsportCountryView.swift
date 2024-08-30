//
//  MotorsportCountryView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI
import QGrid

struct MotorsportCountryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    @State var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        SportCountryView {
            motorsportPageVM.add(by: .Country)
            motorsportPageVM.setCurrent(by: .Leagues)
        }
        /*
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(countryVM.modelsFilter.count > 0 ? countryVM.modelsFilter : countryVM.models, id: \.id) { country in
                        
                        country.getItemView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        //.rotateOnAppear()
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                        .onTapGesture {
                            appVM.loading = true
                            withAnimation(.spring()) {
                                UIApplication.shared.endEditing() // Dismiss the keyboard
                                
                                appVM.resetTextSearch()
                                countryVM.resetFilter()
                                countryVM.setDetail(by: country)
                                
                                motorsportPageVM.addPage(by: .Country)
                                motorsportPageVM.setCurrentPage(by: .Leagues)
                                //soccerPageVM.addPage(by: .Leagues)
                                leaguesVM.resetModels()
                                leaguesVM.fetch(from: country, by: sportTypeVM.selected) {
                                    appVM.loading = false
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

