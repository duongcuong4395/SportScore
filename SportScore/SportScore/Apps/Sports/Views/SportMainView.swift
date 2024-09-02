//
//  SportMainView.swift
//  SportScore
//
//  Created by pc on 25/07/2024.
//

import SwiftUI

enum DateEnum: String, CaseIterable {
    case Yesterday
    case Today
    case Tomorrow
    
    func getDateString() -> String{
        switch self {
        case .Yesterday:
            return DateUtility.calculateDate(offset: -1)
        case .Today:
            return DateUtility.calculateDate(offset: 0)
        case .Tomorrow:
            return DateUtility.calculateDate(offset: 1)
        }
    }
}

struct SportMainView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    
    var body: some View {
        VStack {
            sportTypeVM.selected.getView()
                .padding(0)
        }
    }
}


struct SportMainView2: View {
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    var body: some View {
        VStack {
            SportView2(pages: sportsPageVM.pages, pageSelected: sportsPageVM.pageSelected)
                .onAppear{
                    if countryVM.modelDetail != nil, leaguesVM.modelDetail == nil {
                        sportsPageVM.add(.Country)
                    }
                }
        }
    }
}


struct BadgeCloseView: View {
    var body: some View {
        Image(systemName: "xmark")
            .font(.caption.bold())
            .padding(5)
            .background(.ultraThinMaterial, in: Circle())
    }
}

import SwiftfulLoadingIndicators

struct LoadingView : View {
    var body: some View {
        ZStack {
            Color(.black)
                .opacity(0.2)
                .ignoresSafeArea(.all)
                .background(.ultraThinMaterial)
            LoadingIndicator(animation: .circleBars, size: .large, speed: .fast)
        }
    }
}

struct SportView: View {
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    var pages: [SportPage]
    var pageSelected: SportPage = .Country
    
    var body: some View {
        VStack {
            HStack {
                ForEach(pages, id: \.self) { page in
                    sportTypeVM.selected.getItemMenuView(by: page)
                }
            }
            ZStack {
                sportTypeVM.selected.getView(by: pageSelected)
            }
            
        }
    }
}



struct SportView2: View {
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    var pages: [SportPage]
    var pageSelected: SportPage = .Country
    
    var body: some View {
        VStack {
            HStack {
                ForEach(pages, id: \.self) { page in
                    sportTypeVM.selected.getItemMenuView2(by: page)
                }
            }
            ZStack {
                sportTypeVM.selected.getView2(by: pageSelected)
            }
            
        }
    }
}
