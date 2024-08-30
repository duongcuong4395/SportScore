//
//  SoccerTeamView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI
import QGrid
import CoreData

struct SoccerTeamView: View {
    
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
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
                LazyVGrid(columns: columns) {
                    ForEach (Array( (teamVM.isLoading ? teamVM.getListEmptyModels(): teamVM.models  ).enumerated()), id: \.element.id) { index, team in
                        team.getOptionView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .x)
                        .onTapGesture {
                        
                            withAnimation(.spring()) {
                                UIApplication.shared.endEditing() // Dismiss the keyboard
                                
                                //soccerPageVM.addPage(by: .Team)
                                //soccerPageVM.setCurrentPage(by: .TeamDetail)
                                soccerPageVM.add(by: .Team)
                                soccerPageVM.setCurrent(by: .TeamDetail)
                                
                                teamVM.setDetail(by: team)
                                
                                //appVM.switchPage(to: .Team)
                                playerVM.resetModels()
                                playerVM.fetch(by: team)
                                scheduleVM.resetModels()
                                scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                                scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                                scheduleVM.getLastEvents(by: team.idTeam ?? "0")
                                
                                equipmentVM.fetch(from: team) {}
                                
                                
                            }
                        }
                        
                    }
                    
                }
                //.redacted(reason: teamVM.isLoading ? .placeholder :  [])
            }
            
        }
        //.frame(height: UIScreen.main.bounds.height/2)
        
          .onChange(of: teamVM.models) { vl, nvl in
              //print("$seasonVM.showRanks:", seasonVM.showRanks.count, seasonVM.modelsRank.count)
              
              // Chỉ khởi tạo showCars nếu nó chưa được khởi tạo hoặc có kích thước không khớp
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
        /*
        QGrid(teamVM.models), columns: 3
              , vPadding: 5, hPadding: 5) { team in
            team.getOptionView(with: {
                EmptyView()
            })
                .padding(0)
                .onTapGesture {
                    
                    withAnimation {
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                        teamVM.setDetail(by: team)
                        
                        //appVM.switchPage(to: .Team)
                        playerVM.resetModels()
                        playerVM.fetch(by: team)
                        scheduleVM.resetModels()
                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
                        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                        equipmentVM.fetch(from: team) {}
                        
                        soccerPageVM.addPage(by: .Team)
                        soccerPageVM.setCurrentPage(by: .TeamDetail)
                        
                    }
                }
        }
        */
        
    }
}


struct TeamItemForListView: View {
    let team: TeamModel
    @State private var isRotated = false

    var body: some View {
        team.getOptionView(with: {
            EmptyView()
        })
        .rotation3DEffect(
            .degrees(isRotated ? 0 : -90),
            axis: (x: 1.0, y: 0.0, z: 0.0)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                isRotated = true
            }
        }
        
    }
}
