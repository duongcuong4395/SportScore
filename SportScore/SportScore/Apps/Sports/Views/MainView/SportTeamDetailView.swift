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
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if let team = teamVM.modelDetail {
                    TeamSocialView(team: team)
                }
                
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
                } else  {
                    Button(action: {
                        DispatchQueueManager.share.runOnMain {
                            withAnimation(.spring()) {
                                let keyCD = GeminiAIManage.shared.getKey(from: context)
                                if keyCD.model.valueItem == "" {
                                    appVM.showDialogView(with: NSLocalizedString("Title_Enter_Key", comment: ""), and: AnyView(GeminiAddKeyView()))
                                }
                                else {
                                    var request = ""
                                    
                                    if AppUtility.getCurrentLanguage().tet.lowercased() != "vi"  {
                                        request = "Please give me more information about the %@ train station named %@ in singapore, under the headings: General Information, Services, Connectivity, Architecture, Special Events, Tips."
                                    } else {
                                        request = "Hãy cho tôi nhiều thông tin hơn về trạm tàu lửa %@ có tên %@ ở singapore, theo các đầu mục: Thông tin chung, Dịch vụ, Kết nối, Kiến trúc,Sự kiện đặc biệt, Mẹo."
                                    }
                                    
                                    
                                    let str = "Hãy cho tôi danh sách tên các cầu thủ của đội \(teamVM.modelDetail?.teamName ?? ""), kết quả về chỉ cần theo định dạng sau: [\"ten cau tu 1\", \"ten cau thu 2\",...]. không mô tả gì thêm."
                                    
                                    let strEn = "Give me a list of players on the \(teamVM.modelDetail?.teamName ?? "") team, the results must be in the following format: [\"name 1\", \"name 2\",...]. no further description."
                                    guard let model = teamVM.modelDetail else { return }
                                    
                                    //let prompt = String(format: strEn, [])
                                    // GeminiAIManage.keyString
                                    DispatchQueueManager.share.runInBackground {
                                        model.GeminiSend(prompt: str, and: false, withKeyFrom: keyCD.model.valueItem) { mes, status in
                                            print("=== Gemini:", str)
                                            print("=== Gemini.result:", mes)
                                            // Chuyển chuỗi thành Data
                                            if let jsonData = mes.data(using: .utf8) {
                                                do {
                                                    // Sử dụng JSONDecoder để chuyển đổi thành mảng String
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
        /*
        .overlay {
            HStack{
                Spacer()
                if let team = teamVM.modelDetail {
                    TeamSocialView(team: team)
                }
                
            }
        }
        */
    }
}
