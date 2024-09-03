//
//  EventView.swift
//  SportScore
//
//  Created by pc on 17/08/2024.
//

import SwiftUI

import Kingfisher
import SwiftfulLoadingIndicators



struct SportEventItemMenuView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    var body: some View {
        VStack {
            if let model = scheduleVM.modelDetail {
                VStack {
                    KFImage(URL(string: model.square ?? ""))
                        .placeholder({ progress in
                            LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                        })
                        .resizable()
                        .scaledToFill()
                        .frame(width: appVM.sizeImage.width, height: appVM.sizeImage.height)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                        
                    Text(model.eventName ?? "")
                        .font(.caption.bold())
                }
            }
        }
        .modifier(BadgeCloseItem(action: {
            withAnimation(.spring()) {
                UIApplication.shared.endEditing()
                sportsPageVM.removeFrom(.Event)
            }
        }))
        .scaleEffect(0.85)
    }
}


struct SportEventView: View {
    @EnvironmentObject var eventVM: EventViewModel
    var body: some View {
        VStack {
            ScheduleListItemView(models: eventVM.listEvent)
        }
        .onAppear{
            print("eventVM:", eventVM.currentRound, eventVM.currentSeason, eventVM.currentLeagueID)
        }
    }
}


struct EventDetailView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var eventVM: EventViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @Environment(\.openURL) var openURL
    var column: [GridItem] = [GridItem(), GridItem()]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    KFImage(URL(string: scheduleVM.modelDetail?.banner ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width/2, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Image(systemName: "play.rectangle")
                        .font(.title)
                        .foregroundStyle(.red)
                        .shadow(color: .red, radius: 5)
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                    guard let model = scheduleVM.modelDetail else { return }
                    guard let video = model.video else { return }
                    guard let url = URL(string: video) else { return }
                    openURL(url)
                }
                
                HStack {
                    Text("Result:")
                        .font(.callout.bold())
                        Spacer()
                }
                
                ScrollView(showsIndicators: false) {
                    LazyVStack{
                        ForEach(eventVM.modelsPlayer, id: \.idResult) { player in
                            PlayerEventView(playerEvent: player)
                        }
                    }
                }
                .frame(height: UIScreen.main.bounds.height/2)
                
                
                HStack {
                    Text("Description:")
                        .font(.callout.bold())
                        Spacer()
                }
                Text(scheduleVM.modelDetail?.descriptionEN ?? "")
                    .font(.caption)
                
                KFImage(URL(string: scheduleVM.modelDetail?.banner ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 10, height: 100)
                
                LazyVGrid(columns: column) {
                    KFImage(URL(string: scheduleVM.modelDetail?.thumb ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                    KFImage(URL(string: scheduleVM.modelDetail?.fanart ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                    
                    KFImage(URL(string: scheduleVM.modelDetail?.mapLoc ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                    
                    KFImage(URL(string: scheduleVM.modelDetail?.square ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                }
                
                KFImage(URL(string: scheduleVM.modelDetail?.poster ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 10, height: 500)
            }
            
        }
        //.padding()
    }
}


struct PlayerEventView: View {
    //@EnvironmentObject var eventVM: EventViewModel
    @StateObject var playerVM = PlayerViewModel()
    @StateObject var equipmentVM = EquipmentViewModel()
    @EnvironmentObject var teamVM: TeamViewModel
    
    
    var playerEvent: PlayerEventModel
    
    @State var equipmentModel =  EquipmentModel()
    @State var team = TeamModel()
    @State var player = PlayerModel()
    
    var body: some View {
        HStack {
            ArrowShape()
                .fill(.green)
                .frame(height: 100)
                .overlay {
                    Text(playerEvent.position ?? "")
                        .font(.callout.bold())
                        .foregroundStyle(.white)
                }
                .frame(width: 40, height: 40)
            
            VStack(spacing: 0) {
                HStack {
                    KFImage(URL(string: player.cutout ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        //.clipShape(Circle())
                        //.frame(width: appVM.sizeImage.width * 2.5, height: appVM.sizeImage.height * 2.5)
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    Text(player.playerName ?? "")
                        .font(.callout.bold())
                    
                    
                    Spacer()
                    KFImage(URL(string: equipmentModel.equipment ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 60)
                }
                
                HStack {
                    KFImage(URL(string: team.badge ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    Text(team.teamName)
                        .font(.caption)
                    Spacer()
                    Text(playerEvent.detail ?? "")
                        .font(.caption)
                }
            }
            
        }
        //.frame(height: 30)
        .onAppear{
            print("playerDetail: ", playerEvent.idPlayer ?? "")
            playerVM.getPlayerDetail(by: playerEvent.idPlayer ?? "") {
                player = playerVM.modelDetail ?? PlayerModel()
            }
            var team = TeamModel()
            team.idTeam = playerEvent.idTeam
            equipmentVM.fetch(from: team) {
                self.equipmentModel = equipmentVM.models[0]
            }
            
            guard let team = teamVM.getTeam(by: playerEvent.idTeam ?? "") else { return }
            self.team = team
        }
    }
}



struct EventItemMenuView: View {
    @EnvironmentObject var eventVM: EventViewModel
    @Namespace var aniamtion
    
    var body: some View {
        if let model = eventVM.eventDetail {
            model.getItemView(and: getOptionView)
                //.matchedGeometryEffect(id: "Lague_\(model.leagueName ?? "")", in: aniamtion)
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {
        
    }
}



