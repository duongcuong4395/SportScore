//
//  SportMainView.swift
//  SportScore
//
//  Created by pc on 25/07/2024.
//

import SwiftUI


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
            sportTypeVM.selected.getView(by: pageSelected)
                .padding(.horizontal, 5)
        }
    }
}

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
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    var body: some View {
        VStack {
            SportView(pages: sportsPageVM.pages, pageSelected: sportsPageVM.pageSelected)
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


struct BadgeCloseItem: ViewModifier {
    var action: () -> Void
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        BadgeCloseView()
                            .frame(alignment: .topTrailing)
                            .onTapGesture {
                                action()
                            }
                    }
                    Spacer()
                }
            }
    }
}

struct ListEventSpecificView: View {
    
    var seasonVM: SeasonViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        VStack {
            VStack {
                if seasonVM.leagueSelected != nil && seasonVM.seasonSelected != nil {
                    if eventVM.listEventInSpecific.count > 0 {
                        HStack {
                            Text("Event Specific")
                                .font(.callout.bold())
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        ScheduleListItemView(models: eventVM.listEventInSpecific)
                            .frame(maxHeight: UIScreen.main.bounds.height / 2.5)
                            .onDisappear{
                                eventVM.listEventInSpecific = []
                            }
                    }
                }
            }
        }
    }
}






struct LeaguesSocisalView: View {
    @Environment(\.openURL) var openURL
    var league : LeaguesModel
    
    var body: some View {
        HStack {
            Button (action: {
                openURL(URL(string: "https://\(league.youtube ?? "")")!)
            }, label: {
                Image("youtube")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            Spacer()
            Button (action: {
                openURL(URL(string: "https://\(league.twitter ?? "")")!)
            }, label: {
                Image("twitter")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            Spacer()
            
            if let instagram = league.instagram {
                if instagram != "" {
                    Button (action: {
                        openURL(URL(string: "https://\(league.instagram ?? "")")!)
                    }, label: {
                        Image("instagram")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                    })
                    Spacer()
                }
            }
            
            Button (action: {
                openURL(URL(string: "https://\(league.facebook ?? "")")!)
            }, label: {
                Image("facebook")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
            Spacer()
            Button (action: {
                openURL(URL(string: "https://\(league.website ?? "")")!)
            }, label: {
                Image("website")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
            })
        }.padding(5)
            .padding(.horizontal, 5)
            .background(.thinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

import Kingfisher
import SwiftfulLoadingIndicators

struct LookuptableLeagueView: View {
    @EnvironmentObject var seasonVM: SeasonViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @State private var showRanks: [Bool] = []
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(Array(seasonVM.modelsRank.enumerated()), id: \.element.id) { index, rank in
                        HStack {
                            ArrowShape()
                                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 40, height: 30)
                                .overlay {
                                    Text(rank.intRank ?? "")
                                        .font(.callout.bold())
                                        .foregroundStyle(.black)
                                }
                                
                            KFImage(URL(string: rank.badge ?? ""))
                                .placeholder { progress in
                                    Image("Sports")
                                        .resizable()
                                        .scaledToFill()
                                        .foregroundStyle(.black)
                                        .opacity(0.3)
                                        .fadeInEffect(duration: 1, isLoop: true)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                                .onTapGesture {
                                    withAnimation {
                                        UIApplication.shared.endEditing()
                                        guard let team = teamVM.getTeam(by: rank.idTeam ?? "") else { return }
                                        selectTeam(from: team)
                                    }
                                }
                            VStack {
                                HStack {
                                    Text(rank.teamName ?? "")
                                        .font(.caption.bold())
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Win: \(rank.winNumber ?? "")   Loss: \(rank.lossNumber ?? "")   Draw: \(rank.drawNumber ?? "")")
                                        .font(.caption)
                                    Spacer()
                                    Text("Points: \(rank.pointsNumber ?? "")")
                                        .font(.caption)
                                }
                            }
                            Spacer()
                        }
                        .sequentiallyAnimating(isVisible: seasonVM.showRanks.indices.contains(index) ?
                                               $seasonVM.showRanks[index] : .constant(false), delay: Double(index) * 0.1, direction: .leftToRight)
                        .onAppear{
                            seasonVM.showRanks[index] = true
                        }
                    }
                }
            }
        }
        .onChange(of: seasonVM.modelsRank) { vl, nvl in
            if seasonVM.showRanks.count != seasonVM.modelsRank.count {
                self.seasonVM.showRanks = Array(repeating: false, count: seasonVM.modelsRank.count)
           }
        }
        .onAppear{
            if seasonVM.showRanks.count != seasonVM.modelsRank.count {
                self.seasonVM.showRanks = Array(repeating: false, count: seasonVM.modelsRank.count)
            }
        }
        .onDisappear{
            seasonVM.resetModelRanks()
            seasonVM.resetSeasonSelected()
        }
    }
       
    
    func selectTeam(from team: TeamModel) {
        teamVM.setDetail(by: team)
        playerVM.resetModels()
        playerVM.fetch(by: team)
        scheduleVM.resetModels()
        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Next, from: context)
        scheduleVM.fetch(by: Int(team.idTeam ?? "0") ?? 0, for: .Previous, from: context)
        equipmentVM.fetch(from: team) {}
        sportsPageVM.add(.Team)
        scheduleVM.modelsForLastEvents = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            scheduleVM.getLastEvents(by: team.idTeam ?? "0")
        }
        
        
    }
}

struct LeaguesAdsView: View {
    var league: LeaguesModel
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            KFImage(URL(string: league.banner ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: 100)
                //.padding()
            
            LazyVGrid(columns: column) {
                KFImage(URL(string: league.fanart1 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart2 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                KFImage(URL(string: league.fanart3 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
                KFImage(URL(string: league.fanart4 ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 100)
                
            }
            //.padding()
            
            KFImage(URL(string: league.poster ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                }
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width - 10, height: 500)
        }
    }
}

struct ListTrophyOfTeamView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    var body: some View {
        HStack {
            if let idLeague = teamVM.modelDetail?.idLeague {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.leagueName ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague2 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league2Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague3 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league3Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague4 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league4Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague5 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league5Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague6 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league6Name ?? ""))
            }
            if let idLeague = teamVM.modelDetail?.idLeague7 {
                SeasonForTaeamView(league: LeaguesModel(idLeague: idLeague, leagueName: teamVM.modelDetail?.league7Name ?? ""))
            }
        }
    }
}

struct SeasonForTaeamView: View {
    @StateObject var seasonVM = SeasonViewModel()
    @State var league: LeaguesModel
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text(league.leagueName ?? "")
                    .font(.caption.bold())
                    .onTapGesture {
                        print("league: \(league.leagueName ?? "")")
                    }
            }
        }
        
        .onAppear {
            print("seasonVM.getAllSeason: ", league.idLeague ?? "", league.leagueName ?? "")
            seasonVM.getAllSeason(by: league)
        }
    }
}

struct TeamSocialView: View {
    @Environment(\.openURL) var openURL
    var team: TeamModel?
    
    var body: some View {
        HStack {
            if let team = team {
                Button (action: {
                    openURL(URL(string: "https://\(team.youtube ?? "")")!)
                }, label: {
                    Image("youtube")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                Spacer()
                Button (action: {
                    openURL(URL(string: "https://\(team.twitter ?? "")")!)
                }, label: {
                    Image("twitter")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                Spacer()
                Button (action: {
                    openURL(URL(string: "https://\(team.instagram ?? "")")!)
                }, label: {
                    Image("instagram")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                Spacer()
                Button (action: {
                    openURL(URL(string: "https://\(team.facebook ?? "")")!)
                }, label: {
                    Image("facebook")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
                Spacer()
                Button (action: {
                    openURL(URL(string: "https://\(team.website ?? "")")!)
                }, label: {
                    Image("website")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                })
            }
        }
        .padding(.horizontal, 5)
        .background(.thinMaterial.opacity(0.9), in: RoundedRectangle(cornerRadius: 25, style: .continuous))
        
    }
}

struct TeamAdsView: View {
    var team: TeamModel
    
    var column: [GridItem] = [GridItem(), GridItem()]
    var body: some View {
        VStack {
            if let logo = team.logo {
                KFImage(URL(string: logo))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 10, height: 100)
            }
            
            
            
            LazyVGrid(columns: column) {
                if let fanart1 = team.fanart1 {
                    KFImage(URL(string: fanart1))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                }
                if let fanart2 = team.fanart2 {
                    KFImage(URL(string: fanart2))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                }
                
                if let fanart3 = team.fanart3 {
                    KFImage(URL(string: fanart3))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                }
                
                if let fanart4 = team.fanart4 {
                    KFImage(URL(string: fanart4))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                }
                
            }
            if let banner = team.banner {
                KFImage(URL(string: banner))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                    }
                    .resizable()
                    .scaledToFit()
            }
        }
        
    }
}

struct SoccerScheduleListItemView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    var models: [ScheduleLeagueModel]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(models) { model in
                    SoccerScheduleItemView(model: model)
                        
                }
            }
        }
    }
}


struct SoccerScheduleItemView: View, ItemDelegate {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @Environment(\.managedObjectContext) var context
    
    var model: ScheduleLeagueModel
    
    var body: some View {
        model.getItemView(and: optionsView)
            .onAppear{
                scheduleVM.checkNotify(of: model, from: context) { isNotify, objCoreData in
                    scheduleVM.toggleNotifyModel(for: model, by: isNotify)
                }
                
                scheduleVM.checkFavorite(of: model, from: context) { isFavorite, objCoreData in
                    scheduleVM.toggleFavoriteModel(for: model, by: isFavorite)
                }
            }
            
    }
    
    @ViewBuilder
    func optionsView() -> some View {
        HStack(spacing: 30) {
            
            
            let now = Date()
            if let dateTimeOfMatch = DateUtility.convertToDate(from: model.timestamp ?? "") {
                if now < dateTimeOfMatch {
                    model.getBtnNotify(with: self)
                }
            }
            
            if model.video?.isEmpty == false {
                model.getBtnOpenVideo(with: self)
            }
            model.getBtnFavorie(with: self)
        }
    }
    
    func toggleFavorite<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        scheduleVM.toggleFavoriteCoreData(for: model, from: context) { liked in
            favoriteVM.getCount(from: sportTypeVM.selected.getEntities(), of: sportTypeVM.selected, from: context)
        }
        UIApplication.shared.endEditing() // Dismiss the keyboard
    }
    
    func toggleNotify<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        UIApplication.shared.endEditing() // Dismiss the keyboard
        
        if lnManager.isGranted {
            scheduleVM.toggleNotifyCoreData(for: model, from: context) { isNotify in
                if isNotify {
                    Task {
                        guard let scheduleDate = DateUtility.convertToDate(from: model.timestamp ?? "") else { return }
                        
                        let dataComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
                        
                        let notifyData: [AnyHashable: Any] = [
                            "idEvent": model.idEvent ?? "",
                            "eventName": model.eventName ?? "",
                            "sportType": model.sportName ?? "",
                            //"homeTeamName": model.homeTeamName ?? "",
                            //"awayTeamName": model.awayTeamName ?? "",
                            "idHomeTeam": model.idHomeTeam ?? "",
                            "idAwayTeam": model.idAwayTeam ?? "",
                            "banner": model.banner ?? "",
                            "timestamp": model.timestamp ?? ""
                        ]
                        
                        let notify = NotificationModel(id: model.idEvent ?? ""
                                                       , title: "Soccer match"
                                                        , body: model.eventName ?? ""
                                                        , datecomponents: dataComponent
                                                        , repeats: false
                                                       , moreData: notifyData)
                        await lnManager.schedule(by: notify)
                    }
                } else {
                    lnManager.removeRequest(with: model.idEvent ?? "")
                }
            }
        } else {
            lnManager.openSettings()
        }
    }
    func openPlayVideo<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        print("model.video", model.video ?? "", model.idEvent ?? "", model.eventName ?? "")
        appVM.showDialogView(with: model.eventName ?? ""
                             , and: ScheduleVideoView(model: model).toAnyView())
    }
}

struct SportEventItemView: View {
    var model: ScheduleLeagueModel
    
    var optionView: AnyView
    
    var body: some View {
        VStack {
            if model.homeTeamName == nil && model.awayTeamName == nil {
                SportSingleEventItemView(model: model, optionView: optionView)
            } else {
                Sport2vs2EventItemView(model: model, optionView: optionView)
            }
        }
    }
}
