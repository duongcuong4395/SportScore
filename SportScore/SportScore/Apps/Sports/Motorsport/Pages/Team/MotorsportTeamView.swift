//
//  MotorsportTeamView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI

struct MotorsportTeamView: View {
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showTeam: [Bool] = []
    
    @State var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: teamVM.columns) {
                    
                    ForEach (Array(teamVM.models.enumerated()), id: \.element.id) { index, team in
                        team.getOptionView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .x)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                UIApplication.shared.endEditing() // Dismiss the keyboard
                                teamVM.setDetail(by: team)
                                
                                playerVM.resetModels()
                                playerVM.fetch(by: team)
                                scheduleVM.resetModels()
                                scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                                scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                                scheduleVM.getLastEvents(by: team.idTeam ?? "0")
                                
                                equipmentVM.fetch(from: team) {}
                                motorsportPageVM.add(by: .Team)
                                motorsportPageVM.setCurrent(by: .TeamDetail)
                            }
                        }
                        
                    }
                }
            }
            
        }
        .onChange(of: teamVM.models) { vl, nvl in
            if showTeam.count != teamVM.models.count {
              self.showTeam = Array(repeating: false, count: teamVM.models.count)
              
              for index in teamVM.models.indices {
                  DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                      withAnimation(.easeInOut(duration: 0.5)) {
                          showTeam[index] = true
                      }
                  }
              }
            }
        }
    }
}
