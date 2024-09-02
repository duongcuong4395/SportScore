//
//  CountryView.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import SwiftUI
import QGrid



struct SportCountryItemMenuView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    var body: some View {
        CountryItemMenuView()
            .modifier(BadgeCloseItem(action: {
                withAnimation(.spring()) {
                    sportsPageVM.removeFrom(.Country)
                    UIApplication.shared.endEditing()
                }
            }))
            .scaleEffect(0.85)
    }
}

// MARK: - For Country
struct SportListCountryView: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        SportCountryView {
            sportsPageVM.add(.Country)
        }
    }
}

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
