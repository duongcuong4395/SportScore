//
//  CountryView.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import SwiftUI
import QGrid

struct CountryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    var body: some View {
        QGrid(appVM.textSearch.isEmpty ? countryVM.models : countryVM.modelsFilter
                , columns: 3) { country in
            country.getItemView(with: getOptionView)
                .padding(0)
                .onTapGesture {
                    appVM.loading = true
                    withAnimation(.spring()) {
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                        appVM.pagesSelected.append(.Country)
                        appVM.switchPage(to: .League)
                        appVM.resetTextSearch()
                        countryVM.resetFilter()
                        countryVM.setDetail(by: country)
                        leaguesVM.resetModels()
                        leaguesVM.fetch(from: country, by: sportTypeVM.selected) {
                            appVM.loading = false
                        }
                        
                        
                    }
                }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        //EmptyView()
    }
}

struct CountryDetailView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    
    var body: some View {
        if let model = countryVM.modelDetail {
            model.getItemView(with: getOptionView)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}

struct CountryItemMenuView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    
    var body: some View {
        if let model = countryVM.modelDetail {
            model.getItemView(with: getOptionView)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}



// MARK: - For Country


struct SportCountryView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var action: () -> Void
    
    var body: some View {
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
                                
                                //soccerPageVM.add(by: .Country)
                                //soccerPageVM.setCurrent(by: .Leagues)
                                action()
                                
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
    }
}
