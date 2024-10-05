//
//  SportTeamDetailView.swift
//  SportScore
//
//  Created by Macbook on 1/10/24.
//

import Foundation
import SwiftUI

struct SportTeamDetailView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                //TeamSocialView(team: teamVM.modelDetail)
                    //.padding(.horizontal, 5)
                if let team = teamVM.modelDetail {
                    SocialView(facebook: team.facebook
                               , twitter: team.twitter
                               , instagram: team.instagram
                               , youtube: team.youtube
                               , website: team.website)
                    .padding(.horizontal, 5)
                }
                
                
                if scheduleVM.modelsForNext.count > 0 || scheduleVM.modelsForPrevious.count > 0 {
                    ComponentGenView(title: "Schedule") {
                        ScheduleView()
                            .frame(height: UIScreen.main.bounds.height / 1.5)
                    }
                    .padding(.horizontal, 5)
                }
                if scheduleVM.modelsForLastEvents.count > 0 {
                    ComponentGenView(title: "Last event:") {
                        ScheduleListItemView(models: scheduleVM.modelsForLastEvents)
                            .onDisappear{
                                scheduleVM.modelsForLastEvents = []
                            }
                    }
                    .padding(.horizontal, 5)
                }
                
                if playerVM.models.count > 0 {
                    ComponentGenView(title: "Players") {
                        PlayerView()
                            .frame(height: UIScreen.main.bounds.height / 2)
                    }
                    .padding(.horizontal, 5)
                } else  {
                    buttonGetPlayersView
                }
                
                
                ComponentGenView(title: "Equipments") {
                    EquipmentView()
                }
                .padding(.horizontal, 5)
                
                /*
                HStack {
                    Text("Trophies:")
                        .font(.callout.bold())
                    Spacer()
                }
                ListTrophyOfTeamView()
                */
                
                ComponentGenView(title: "Description:") {
                    Text(teamVM.modelDetail?.descriptionEN ?? "")
                        .font(.caption)
                        .lineLimit(nil)
                        .frame(alignment: .leading)
                }
                .padding(.horizontal, 5)
                
                if let team = teamVM.modelDetail {
                    TeamAdsView(team: team)
                       // .padding(.horizontal, 5)
                }
            }
        }
        .onAppear{
            scheduleVM.getLastEvents(by: teamVM.modelDetail?.idTeam ?? "0")
        }
    }
    
    var buttonGetPlayersView: some View {
        Button(action: {
            DispatchQueueManager.share.runOnMain {
                withAnimation(.spring()) {
                    let keyCD = GeminiAIManage.shared.getKey(from: context)
                    if keyCD.model.valueItem == "" {
                        appVM.showDialogView(with: NSLocalizedString("Title_Enter_Key", comment: ""), and: AnyView(GeminiAddKeyView()))
                    }
                    else {
                        guard let model = teamVM.modelDetail else { return }
                        
                        let str = "Hãy cho tôi danh sách tên các cầu thủ của đội \(teamVM.modelDetail?.teamName ?? "") của môn thể thao \(sportTypeVM.selected.rawValue), kết quả về chỉ cần theo định dạng sau: [\"ten cau tu 1\", \"ten cau thu 2\",...], nếu không thể lấy danh sách cầu thủ thì chỉ cần trả về theo định dạng sau: []. không mô tả gì thêm."
                        DispatchQueueManager.share.runInBackground {
                            model.GeminiSend(prompt: str, and: false, withKeyFrom: keyCD.model.valueItem) { mes, status in
                                print("=== Gemini:", str)
                                print("=== key", keyCD.model.valueItem)
                                print("=== Gemini.result:", mes)
                                
                            
                                if let jsonData = mes.data(using: .utf8) {
                                    do {
                                        let listPlayerName = try JSONDecoder().decode([String].self, from: jsonData)
                                        print(listPlayerName)
                                        playerVM.listPlayerName = listPlayerName
                                        
                                        playerVM.searchPlayers()
                                    } catch {
                                        print("Lỗi khi giải mã JSON:", error)
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
        }, label: {
            HStack {
                Image(systemName: "person.3.fill")
                    .resizable()
                    .scaledToFill()
                    .font(.caption2)
                    .frame(width: 20, height: 20)
                Text("View Players")
                    .font(.callout)
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        })
    }
}

