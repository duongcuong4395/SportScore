//
//  LeaguesModel.swift
//  SportScore
//
//  Created by pc on 09/08/2024.
//

import Foundation

struct LeaguesResponse: Codable {
    var leagues: [LeaguesModel]?
    
    enum CodingKeys: String, CodingKey {
        case leagues = "countries"
    }
}

struct LeaguesModel: Codable, Identifiable, Hashable {
    var id: String = "" //UUID = UUID()
    var idLeague: String? = ""
    var idSoccerXML: String? = ""
    var idAPIfootball: String? = ""
    
    var sportType: SportType? = .AmericanFootball
    var leagueName: String?  = ""
    var leagueAlternate: String? = ""
    var division: String? = ""
    var idCup: String? = ""
    
    var currentSeason: String? = ""
    var formedYear: String? = ""
    var dateFirstEvent: String? = ""
    var gender: String? = ""
    var country: String? = ""
    var website: String? = ""
    var facebook: String? = ""
    var instagram: String? = ""
    var twitter: String? = ""
    var youtube: String? = ""
    var rss: String? = ""
    
    var descriptionEN: String? = ""
    var descriptionDE: String? = ""
    var descriptionFR: String? = ""
    var descriptionIT: String? = ""
    
    var descriptionCN: String? = ""
    var descriptionJP: String? = ""
    var descriptionRU: String? = ""
    var descriptionES: String? = ""
    
    var descriptionPT: String? = ""
    var descriptionSE: String? = ""
    var descriptionNL: String? = ""
    var descriptionHU: String? = ""
    
    var descriptionNO: String? = ""
    var descriptionPL: String? = ""
    var descriptionIL: String? = ""
    var tvRights: String? = ""
    
    var fanart1: String? = ""
    var fanart2: String? = ""
    var fanart3: String? = ""
    var fanart4: String? = ""
    
    var banner: String? = ""
    var badge: String? = ""
    var logo: String? = ""
    var poster: String? = ""
    var trophy: String? = ""
    var naming: String? = ""
    var complete: String? = ""
    var locked: String? = ""
    
    
    
    enum CodingKeys: String, CodingKey {
        case idLeague, idSoccerXML
        case idAPIfootball
        
        case sportType = "strSport"
        case leagueName = "strLeague"
        case leagueAlternate = "strLeagueAlternate"
        case division = "intDivision"
        case idCup
        
        case currentSeason = "strCurrentSeason"
        case formedYear = "intFormedYear"
        case dateFirstEvent
        case gender = "strGender"
        case country = "strCountry"
        case website = "strWebsite"
        case facebook = "strFacebook"
        case instagram = "strInstagram"
        case twitter = "strTwitter"
        case youtube = "strYoutube"
        case rss = "strRSS"
        
        case descriptionEN = "strDescriptionEN"
        case descriptionDE = "strDescriptionDE"
        case descriptionFR = "strDescriptionFR"
        case descriptionIT = "strDescriptionIT"
        
        case descriptionCN = "strDescriptionCN"
        case descriptionJP = "strDescriptionJP"
        case descriptionRU = "strDescriptionRU"
        case descriptionES = "strDescriptionES"
        
        case descriptionPT = "strDescriptionPT"
        case descriptionSE = "strDescriptionSE"
        case descriptionNL = "strDescriptionNL"
        case descriptionHU = "strDescriptionHU"
        
        case descriptionNO = "strDescriptionNO"
        case descriptionPL = "strDescriptionPL"
        case descriptionIL = "strDescriptionIL"
        case tvRights = "strTvRights"
        
        case fanart1 = "strFanart1"
        case fanart2 = "strFanart2"
        case fanart3 = "strFanart3"
        case fanart4 = "strFanart4"
        
        case banner = "strBanner"
        case badge = "strBadge"
        case logo = "strLogo"
        case poster = "strPoster"
        case trophy = "strTrophy"
        case naming = "strNaming"
        case complete = "strComplete"
        case locked = "strLocked"
    }
    
}

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension LeaguesModel {
    func getItemView(showDetail: Bool = false, with optionView: () -> some View) -> some View {
        LeaguesItemView(model: self, showDetail: showDetail)
    }
}




struct LeaguesItemView: View {
    @EnvironmentObject var appVM: AppViewModel
    let model: LeaguesModel
    
    let showDetail: Bool
    
    var body: some View {
        VStack {
            KFImage(URL(string: model.badge ?? ""))
                .placeholder({ progress in
                    //LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                    
                    Image("website")
                        .resizable()
                        .scaledToFill()
                        //.clipShape(Circle())
                })
                .resizable()
                .scaledToFill()
                .frame(width: appVM.sizeImage.width, height: appVM.sizeImage.height)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                
            Text(model.leagueName ?? "")
                .font(.caption.bold())
                
                
            Text(model.currentSeason ?? "")
                .font(.caption2)
            
            if showDetail {
                Text("Description:")
                    .font(.callout.bold())
                    .frame(alignment: .leading)
                Text(model.descriptionEN ?? "")
                    .lineLimit(nil)
                    .frame(alignment: .leading)
            }
        }
    }
}
