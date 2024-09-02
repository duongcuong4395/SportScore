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
            /*
            HStack {
                TextFieldSearchView(listModels: []) {
                    
                }
                NotificationBellView()
            }
            .padding(.horizontal, 5)
            */
            sportTypeVM.selected.getView()
                .padding(0)
            
            
        }
        .onAppear{
            //countryVM.fetch()
        }
        .onChange(of: appVM.textSearch) { olddVl, newVl in
            withAnimation(.spring()) {
                
            }
        }
    }
}
/*
 
 .onChange(of: appVM.textSearch) { olddVl, newVl in
     withAnimation(.spring()) {
         filterCountry(by: appVM.textSearch)
     }
 }
 .task {
     favoriteVM.getCount(from: sportTypeVM.selected.getEntities(), of: sportTypeVM.selected, from: context)
 }
 
 
 
 */



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
