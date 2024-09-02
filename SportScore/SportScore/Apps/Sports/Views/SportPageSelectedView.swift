//
//  SportPageSelectedView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SportPageSelectedView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        if countryVM.modelDetail != nil {
            HStack {
                CountryDetailView()
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                BadgeCloseView()
                                    .frame(alignment: .topTrailing)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            //appVM.switchPage(to: .Country)
                                            UIApplication.shared.endEditing() // Dismiss the keyboard
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                //countryVM.resetDetail()
                                                //leaguesVM.resetDetail()
                                                //teamVM.resetDetail()
                                                //playerVM.resetDetail()
                                                
                                            }
                                            
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                    }
                    .scaleEffect(0.85)
                
                LeaguesDetailView()
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                BadgeCloseView()
                                    .frame(alignment: .topTrailing)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            UIApplication.shared.endEditing() // Dismiss the keyboard
                                            leaguesVM.resetDetail()
                                            teamVM.resetDetail()
                                            playerVM.resetDetail()
                                            //appVM.switchPage(to: .League)
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                    }
                    .scaleEffect(0.85)
                
                TeamDetailMenuView()
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                BadgeCloseView()
                                    .frame(alignment: .topTrailing)
                                    .onTapGesture {
                                        appVM.loading = false
                                        withAnimation(.spring()) {
                                            UIApplication.shared.endEditing() // Dismiss the keyboard
                                            teamVM.resetDetail()
                                            //appVM.switchPage(to: .Team)
                                            
                                            if let league = leaguesVM.modelDetail {
                                                scheduleVM.resetModels()
                                                scheduleVM.fetch(from: league, for: .Next, from: context) { success in
                                                }
                                                scheduleVM.fetch(from: league, for: .Previous, from: context) {
                                                    success in
                                                    appVM.loading = false
                                                }
                                            }
                                            //appVM.switchPage(to: .LeagueDetail)
                                        }
                                    }
                            }
                            
                            Spacer()
                        }
                    }
                    .scaleEffect(0.85)
                Spacer()
            }
            
        }
    }
}
