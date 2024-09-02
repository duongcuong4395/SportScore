//
//  SportView.swift
//  SportScore
//
//  Created by pc on 13/08/2024.
//

import SwiftUI
import QGrid
import Kingfisher
import SwiftfulLoadingIndicators

struct SportTypeView: View {
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(SportType.allCases, id: \.self) { sport in
                        
                        if sport != .Darts {
                            VStack {
                                KFImage(URL(string: sport.getImageUrl(with: sport == sportTypeVM.selected)
                                           ))
                                    .placeholder { progress in
                                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                    }
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    
                                Text(sport.rawValue)
                                    .font(sport == sportTypeVM.selected ? .caption.bold() : .caption)
                            }
                            .padding(.horizontal, 5)
                            
                            .onTapGesture {
                                withAnimation {
                                    if sportTypeVM.selected == sport {
                                        return
                                    }
                                    sportTypeVM.selected = sport
                                    sportsPageVM.removeFrom(.Country)
                                    leaguesVM.resetAll()
                                    teamVM.resetAll()
                                    playerVM.resetAll()
                                    scheduleVM.resetAll()
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .frame(height: 50)
        .padding(5)
        .padding(.horizontal, 10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 35, style: .continuous))
    }
}

