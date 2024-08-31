//
//  FightingTeamDetailView.swift
//  SportScore
//
//  Created by pc on 31/08/2024.
//

import SwiftUI

struct FightingTeamDetailView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if scheduleVM.modelsForNext.count > 0 || scheduleVM.modelsForPrevious.count > 0 {
                    HStack {
                        Text("Schedule")
                            .font(.callout.bold())
                        Spacer()
                    }
                    ScheduleView()
                        .frame(height: UIScreen.main.bounds.height / 1.5)
                }
                if scheduleVM.modelsForLastEvents.count > 0 {
                    HStack {
                        Text("Last event:")
                            .font(.callout.bold())
                        Spacer()
                    }
                    
                    ScheduleListItemView(models: scheduleVM.modelsForLastEvents)
                        .onDisappear{
                            scheduleVM.modelsForLastEvents = []
                        }
                }
                
                if playerVM.models.count > 0 {
                    HStack {
                        Text("Players")
                            .font(.callout.bold())
                        Spacer()
                    }
                    PlayerView()
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                
                
                HStack {
                    Text("Equipments")
                        .font(.callout.bold())
                    Spacer()
                }
                EquipmentView()
                
                
                HStack {
                    Text("Trophies:")
                        .font(.callout.bold())
                    Spacer()
                }
                ListTrophyOfTeamView()
                
                HStack {
                    Text("Description:")
                        .font(.callout.bold())
                    Spacer()
                }
                Text(teamVM.modelDetail?.descriptionEN ?? "")
                
                if let team = teamVM.modelDetail {
                    TeamAdsView(team: team)
                }
            }
        }
        .onAppear{
            scheduleVM.getLastEvents(by: teamVM.modelDetail?.idTeam ?? "0")
        }
        .overlay {
            HStack{
                Spacer()
                if let team = teamVM.modelDetail {
                    TeamSocialView(team: team)
                }
                
            }
        }
    }
}
