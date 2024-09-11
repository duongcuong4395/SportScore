//
//  PlayerModel.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import Foundation


// MARK: - TwoHourWeatherForecast
struct PlayerResponse: Codable {
    var players: [PlayerModel]?
}

// MARK: - TwoHourWeatherForecast
struct PlayerDetailResponse: Codable {
    var player: [PlayerModel]?
}

// MARK: - Player
struct PlayerModel: Codable, Identifiable {
    var id: UUID = UUID()
    var idPlayer, playerName, idTeam, idTeam2: String?
    var playerAlternate: String?
    var idTeamNational, idSoccerXML, idAPIfootball, intSoccerXMLTeamID: String?
    
    var idPlayerManager, idWikidata: String?
    var teamName: String?
    var team2Name: String?
    
    var nationality: String?
    
    var thumb: String?
    var cutout, render: String?
    
    var dateBorn, position: String?
    
    var sportName, status: String?
    var number, agent, ethnicity: String?
    var dateSigned, birthLocation: String?
    var signing, wage, outfitter, kit: String?
    
    
    var gender, side, college: String?
    
    
    
    
    
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
    
    var facebook, website, twitter, instagram, youtube: String?
    var height, weight, banner, creativeCommons: String?
    var strFanart1, strFanart2, strFanart3, strFanart4: String?
    var locked, intLoved: String?
    
    enum CodingKeys: String, CodingKey {
        case idPlayer, idAPIfootball
        case idPlayerManager, idWikidata
        case intSoccerXMLTeamID
        
        case locked = "strLocked"
        case creativeCommons = "strCreativeCommons"
        case strFanart1, strFanart2, strFanart3, strFanart4
        case banner = "strBanner"
        case intLoved
        case weight = "strWeight"
        case height = "strHeight"
        
        case youtube = "strYoutube"
        case instagram = "strInstagram"
        case twitter = "strTwitter"
        case facebook = "strFacebook"
        case website = "strWebsite"
        case nationality = "strNationality"
        case playerName = "strPlayer"
        case playerAlternate = "strPlayerAlternate"
        case idTeam, idTeam2, idTeamNational, idSoccerXML
        case teamName = "strTeam"
        case team2Name = "strTeam2"
        case thumb = "strThumb"
        case cutout = "strCutout"
        case render = "strRender"
        case dateBorn, dateSigned
        case position = "strPosition"
        case sportName = "strSport"
        
        case college = "strCollege"
        case side = "strSide"
        
        case gender = "strGender"
        case birthLocation = "strBirthLocation"
        case number = "strNumber"
        case signing = "strSigning"
        case wage = "strWage"
        case outfitter = "strOutfitter"
        case kit = "strKit"
        case agent = "strAgent"
        case ethnicity = "strEthnicity"
        case status = "strStatus"
        
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
    }
}

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

extension PlayerModel {
    
    func getView(with optionView: () -> some View) -> some View {
        PlayerItemView(model: self)
    }
}





struct PlayerItemView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    let model: PlayerModel
    
    var body: some View {
        VStack {
            
            HStack {
                
                
                KFImage(URL(string: sportTypeVM.selected == .Motorsport ? model.cutout ?? "" : model.render ?? ""))
                    .placeholder { progress in
                        LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    }
                    .resizable()
                    .scaledToFill()
                    //.clipShape(Circle())
                    .frame(width: appVM.sizeImage.width * 2.5, height: appVM.sizeImage.height * 2.5)
                    .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                    
            }
            
            Text(model.playerName ?? "")
                .font(.callout.bold())
            Text(model.position ?? "")
                .font(.caption.bold())
        }
        //.fixedSize(horizontal: false, vertical: false)
    }
}
