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
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: countryVM.columns) {
                    ForEach(countryVM.modelsFilter.count > 0 ? countryVM.modelsFilter : countryVM.models, id: \.id) { country in
                        SportCountryItemView(country: country)
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                        
                        .onTapGesture {
                            withAnimation(.spring()) {
                                UIApplication.shared.endEditing()
                                appVM.resetTextSearch()
                                Task {
                                    
                                    countryVM.resetFilter()
                                    countryVM.setDetail(by: country)
                                    leaguesVM.resetModels()
                                    
                                    action()
                                    
                                    await leaguesVM.fetchLeagues(from: country, by: sportTypeVM.selected.rawValue)
                                    
                                    if leaguesVM.models.count <= 0 {
                                        sportsPageVM.removeFrom(.Country)
                                        appVM.showDialogView(with: " What a pity! 􀙌", and: NoLeaguesView(objName: country.fullName).toAnyView(), then: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct NoLeaguesView: View {
    var objName: String
    var body: some View {
        Text(Image(systemName: "face.dashed.fill"))
            .font(.system(size: 13, design: .serif))
        +
        Text(" We couldn't find any leagues in \(objName)! ")
            .font(.system(size: 13, design: .serif))
        +
        Text(Image(systemName: "face.dashed.fill"))
            .font(.system(size: 13, design: .serif))
    }
}

struct SportCountryItemView: View {
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @State var numb: Int = 0
    var country: CountryModel
    
    var body: some View {
        country.getItemView(with: {
            EmptyView()
        })
        /*
        .overlay {
            Text("\(numb)")
        }
        .onChange(of: sportTypeVM.selected, { oldValue, newValue in
            if let cachedCount = leaguesVM.leagueCounts["\(country.fullName)_\(sportTypeVM.selected.rawValue)"] {
                self.numb = cachedCount  // Use cached value
            } else {
                Task {
                    self.numb = await leaguesVM.countLeagues2(from: country, by: sportTypeVM.selected.rawValue)
                }
            }
        })
        .onAppear{
            if let cachedCount = leaguesVM.leagueCounts["\(country.fullName)_\(sportTypeVM.selected.rawValue)"] {
                self.numb = cachedCount  // Use cached value
            } else {
                Task {
                    self.numb = await leaguesVM.countLeagues2(from: country, by: sportTypeVM.selected.rawValue)
                }
            }
        }
        */
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
