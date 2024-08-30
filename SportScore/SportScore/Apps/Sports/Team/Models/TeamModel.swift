//
//  TeamModel.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import Foundation


struct TeamResponse: Codable {
    var teams: [TeamModel]?
}

struct TeamModel: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var idTeam: String? = ""
    var idSoccerXML: String? = ""
    var idAPIfootball: String? = ""
    
    var loved: String? = ""
    var teamName: String = ""
    var teamAlternate: String? = ""
    
    var sportType: SportType? = .AmericanFootball
    var leagueName: String?  = ""
    var leagueAlternate: String? = ""
    var division: String? = ""
    var idCup: String? = ""
    
    var currentSeason: String? = ""
    var formedYear: String? = ""
    var dateFirstEvent: String? = ""
    
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
    
    var colour1: String? = ""
    var colour2: String? = ""
    var colour3: String? = ""
    
    var gender: String? = ""
    var country: String? = ""
    
    var banner: String? = ""
    var badge: String? = ""
    var logo: String? = ""
    
    var fanart1: String? = ""
    var fanart2: String? = ""
    var fanart3: String? = ""
    var fanart4: String? = ""
    
    var equipment: String? = ""
    var locked: String? = ""
    
    var teamShort: String? = ""
    
    var idLeague: String? = ""
    var league2Name: String? = ""
    var idLeague2: String? = ""
    var league3Name: String? = ""
    var idLeague3: String? = ""
    var league4Name: String? = ""
    var idLeague4: String? = ""
    var league5Name:String? = ""
    var idLeague5: String? = ""
    var league6Name: String? = ""
    var idLeague6: String? = ""
    var league7Name: String? = ""
    var idLeague7: String? = ""
    
    var divisionName: String? = ""
    var idVenue: String? = ""
    var stadiumName: String? = ""
    var keywords: String? = ""
    
    var locationName: String? = ""
    var stadiumCapacity: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case idTeam, idSoccerXML
        case idAPIfootball
        
        case loved = "intLoved"
        case teamName = "strTeam"
        case teamAlternate = "strTeamAlternate"
        
        
        case sportType = "strSport"
        case leagueName = "strLeague"
        case leagueAlternate = "strLeagueAlternate"
        case division = "intDivision"
        case idCup
        
        case currentSeason = "strCurrentSeason"
        case formedYear = "intFormedYear"
        case dateFirstEvent
        
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
        
        case colour1 = "strColour1"
        case colour2 = "strColour2"
        case colour3 = "strColour3"
        
        case gender = "strGender"
        case country = "strCountry"
        
        case fanart1 = "strFanart1"
        case fanart2 = "strFanart2"
        case fanart3 = "strFanart3"
        case fanart4 = "strFanart4"
        
        case badge = "strBadge"
        case banner = "strBanner"
        case logo = "strLogo"
        
        case equipment = "strEquipment"
        case locked = "strLocked"
        
        case teamShort = "strTeamShort"
        case idLeague = "idLeague"
        case league2Name = "strLeague2"
        case idLeague2 = "idLeague2"
        case league3Name = "strLeague3"
        case idLeague3 = "idLeague3"
        case league4Name = "strLeague4"
        case idLeague4 = "idLeague4"
        case league5Name = "strLeague5"
        case idLeague5 = "idLeague5"
        case league6Name = "strLeague6"
        case idLeague6 = "idLeague6"
        case league7Name = "strLeague7"
        case idLeague7 = "idLeague7"
        
        case divisionName = "strDivision"
        case idVenue = "idVenue"
        case stadiumName = "strStadium"
        case keywords = "strKeywords"
                    
        case locationName = "strLocation"
        case stadiumCapacity = "intStadiumCapacity"
    }
}


import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension TeamModel {
    
    func getOptionView(with optionView: () -> some View) -> some View {
        TeamItemView(model: self)
    }
}


struct TeamItemView: View {
    @EnvironmentObject var appVM: AppViewModel
    let model: TeamModel
    
    var body: some View {
        
        VStack{
            KFImage(URL(string: model.badge ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                }
                .resizable()
                .scaledToFill()
                .frame(width: appVM.sizeImage.width, height: appVM.sizeImage.height)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
            Text(model.teamName)
                .font(.caption.bold())
            
            
        }
    }
}
