//
//  ScheduleModel.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import Foundation


struct EventsResponse: Codable {
    var events: [ScheduleLeagueModel]?
}

struct LastEventsResponse: Codable {
    var results: [ScheduleLeagueModel]?
}

struct ScheduleLeagueResponse: Codable {
    var scheduleLeagues: [ScheduleLeagueModel]?

    enum CodingKeys: String, CodingKey {
        case scheduleLeagues = "1"
    }
}

struct ScheduleLeagueModel: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    
    var idEvent: String?
    var idSoccerXML: String?
    var idAPIfootball, eventName, eventAlternateName, filename: String?
    var sportName, idLeague, leagueName, seasonName: String?
    var descriptionEN, homeTeamName, awayTeamName: String?
    var homeScore: String?
    var roundNumber: String?
    var awayScore, spectators: String?
    var officialName, timestamp, dateEvent, dateEventLocal: String?
    var dateEventEnd, time, timeLocal, group: String?
    var idHomeTeam: String?
    var homeTeamBadge: String?
    var idAwayTeam: String?
    var awayTeamBadge: String?
    var intScore, intScoreVotes: String?
    var strResult, idVenue, venue, countryName: String?
    var cityName: String?
    var poster, square: String?
    var fanart: String?
    var thumb, banner: String?
    var mapLoc: String?
    var tweet1, tweet2, tweet3, video: String?
    var status, postponed, locked: String?
    
    var isFavorite: Bool? = false
    var isNotify: Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case idEvent = "idEvent"
        case idSoccerXML = "idSoccerXML"
        case idAPIfootball = "idAPIfootball"
        case eventName = "strEvent"
        case eventAlternateName = "strEventAlternate"
        case filename = "strFilename"
        case sportName = "strSport"
        case idLeague = "idLeague"
        case leagueName = "strLeague"
        case seasonName = "strSeason"
        case descriptionEN = "strDescriptionEN"
        case homeTeamName = "strHomeTeam"
        case awayTeamName = "strAwayTeam"
        case homeScore = "intHomeScore"
        case roundNumber = "intRound"
        case awayScore = "intAwayScore"
        case spectators = "intSpectators"
        case officialName = "strOfficial"
        case timestamp = "strTimestamp"
        case dateEvent = "dateEvent"
        case dateEventLocal = "dateEventLocal"
        case dateEventEnd = "dateEventEnd"
        case time = "strTime"
        case timeLocal = "strTimeLocal"
        case group = "strGroup"
        case idHomeTeam = "idHomeTeam"
        case homeTeamBadge = "strHomeTeamBadge"
        case idAwayTeam = "idAwayTeam"
        case awayTeamBadge = "strAwayTeamBadge"
        case intScore = "intScore"
        case intScoreVotes = "intScoreVotes"
        case strResult = "strResult"
        case idVenue = "idVenue"
        case venue = "strVenue"
        case countryName = "strCountry"
        case cityName = "strCity"
        case poster = "strPoster"
        case square = "strSquare"
        case fanart = "strFanart"
        case thumb = "strThumb"
        case banner = "strBanner"
        case mapLoc = "strMap"
        case tweet1 = "strTweet1"
        case tweet2 = "strTweet2"
        case tweet3 = "strTweet3"
        case video = "strVideo"
        case status = "strStatus"
        case postponed = "strPostponed"
        case locked = "strLocked"
    }
    
}

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension ScheduleLeagueModel {
    
    func getItemView(and optionsView: @escaping () -> some View) -> some View {
        ZStack {
            ScheduleLeagueModelItemView(model: self, optionView: AnyView(optionsView()))
        }
    }
}

struct ScheduleLeagueModelItemView: View {
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    
    var model: ScheduleLeagueModel
    
    var optionView: AnyView
    
    var body: some View {
        VStack {
            switch sportTypeVM.selected {
            case .Motorsport:
                ScheduleMotorsportModelItemView(model: model, optionView: optionView)
            case .Soccer:
                SoccerScheduleIModeltemView(model: model, optionView: optionView)
            case .Darts: EmptyView()
            case .Fighting:
                FightingScheduleIModeltemView(model: model, optionView: optionView)
            case .IceHockey:
                IceHockeyEventItemView(model: model, optionView: optionView)
            case .Baseball:
                BaseballEventItemView(model: model, optionView: optionView)
            case .Basketball:
                BasketballEventItemView(model: model, optionView: optionView)
            case .AmericanFootball:
                AmericanFootballEventItemView(model: model, optionView: optionView)
            case .Golf:
                GolfEventItemView(model: model, optionView: optionView)
            case .Rugby:
                RugbyEventItemView(model: model, optionView: optionView)
            case .Tennis, .Cricket, .Cycling, .AustralianFootball, .Esports
                , .Volleyball, .Netball, .Handball, .Snooker, .FieldHockey, .Athletics
                , .Badminton, .Climbing, .Equestrian, .Gymnastics, .Shooting
                , .ExtremeSports, .TableTennis, .MultiSports, .Watersports
                , .Weightlifting, .Skiing, .Skating, .Wintersports
                , .Lacrosse, .Gambling:
                
                EmptyView()
            }
        }
        
        /*
        VStack(spacing: 0) {
            if sportTypeVM.selected == .Motorsport {
                ScheduleMotorsportModelItemView(model: model, optionView: optionView)
            } else {
                // MARK: - Date Time
                HStack {
                    HStack {
                        Text(AppUtility.formatDate(from: model.timestamp, to: "dd/MM") ?? "")
                            .font(.caption2.bold())
                            
                        Text(model.roundNumber ?? "")
                            .font(.caption2.bold())
                        Text(AppUtility.formatDate(from: model.timestamp, to: "hh:mm") ?? "")
                            .font(.caption2.bold())
                    }
                    .padding(5)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    Spacer()
                    
                    optionView
                }
                .padding(.horizontal, 50)
                .padding(.trailing, 20)
                
                // MARK: - Home and Away
                HStack {
                    
                    KFImage(URL(string: model.homeTeamBadge ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .offset(y: -20)
                    
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                        .onTapGesture {
                            var homeTeam = TeamModel()
                            homeTeam.idTeam = model.idHomeTeam // idAwayTeam
                            homeTeam.teamName = model.homeTeamName ?? ""
                            homeTeam.badge = model.homeTeamBadge ?? ""
                            teamVM.setDetail(by: homeTeam)
                            
                            playerVM.resetModels()
                            playerVM.fetch(by: homeTeam)
                            scheduleVM.resetModels()
                            scheduleVM.fetch(by: Int(homeTeam.idTeam ?? "0") ?? 0, for: .Next, from: context)
                            scheduleVM.fetch(by: Int(homeTeam.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                            equipmentVM.fetch(from: homeTeam) {}
                            appVM.switchPage(to: .TeamDetail)
                        }
                
                    Text(model.homeTeamName ?? "")
                        .font(.caption.bold())
                        .lineLimit(2)
                        .frame(width: 90)
                    Spacer()
                    
                    if ((model.homeScore?.isEmpty) == nil) || model.homeScore == "" {
                        Text("VS")
                            .font(.callout.bold())
                    } else {
                        Text("\(model.homeScore ?? "") - \(model.awayScore ?? "")")
                            .font(.callout)
                            .font(.system(size: 9, weight: .bold, design: .default))
                    }
                    
                    
                    Spacer()
                    Text(model.awayTeamName ?? "")
                        .font(.caption.bold())
                        .lineLimit(2)
                        .frame(width: 90)
                    
                    KFImage(URL(string: model.awayTeamBadge ?? ""))
                        .placeholder { progress in
                            LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .offset(y: -20)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                        .onTapGesture {
                            var awayTeam = TeamModel()
                            awayTeam.idTeam = model.idAwayTeam
                            awayTeam.teamName = model.awayTeamName ?? ""
                            awayTeam.badge = model.awayTeamBadge ?? ""
                            teamVM.setDetail(by: awayTeam)
                            
                            playerVM.resetModels()
                            playerVM.fetch(by: awayTeam)
                            scheduleVM.resetModels()
                            scheduleVM.fetch(by: Int(awayTeam.idTeam ?? "0") ?? 0, for: .Next, from: context)
                            scheduleVM.fetch(by: Int(awayTeam.idTeam ?? "0") ?? 0, for: .Previous, from: context)
                            equipmentVM.fetch(from: awayTeam){}
                            appVM.switchPage(to: .TeamDetail)
                        }
                    
                    
                }
                .padding(0)
                .padding(.vertical, 5)
                .background(
                    EmptyView()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                )
            }
        }
        */
        
    }
}



