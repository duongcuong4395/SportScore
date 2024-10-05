//
//  PlayerViewModel.swift
//  SportScore
//
//  Created by pc on 11/08/2024.
//

import Foundation

class PlayerViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [PlayerModel] = []
    @Published var modelDetail: PlayerModel?
    @Published var listPlayerName: [String] = []
    
    let playerDefault = PlayerModel(
        playerName: "David de Gea"
        , thumb: "https://www.thesportsdb.com/images/media/player/thumb/xt634x1510319724.jpg"
        , cutout: "https://www.thesportsdb.com/images/media/player/cutout/beix281723277806.png", render: "https://www.thesportsdb.com/images/media/player/render/r8k9pm1557909726.png", dateBorn: "1990-11-07"
        , position: "Goalkeeper", dateSigned: "2011-06-29"
        , descriptionEN: "David de Gea Quintana (Spanish pronunciation:  ⓘ; born 7 November 1990) is a Spanish professional footballer who plays as a goalkeeper for Serie A club Fiorentina and the Spain national team.\r\n\r\nBorn in Madrid, Spain, De Gea began his playing career with Atlético Madrid, rising through the academy system at the club before making his senior debut in 2009, aged 18. After being made Atlético's first-choice goalkeeper, he helped the team win the UEFA Europa League and the UEFA Super Cup in 2010. His performances subsequently attracted the attention of Manchester United, and De Gea joined the club in 2011 for £18.9 million, a British record for a goalkeeper at the time.\r\n\r\nDuring his time at Manchester United, De Gea made over 500 appearances and won a Premier League title, an FA Cup, two League Cups, three Community Shields and the UEFA Europa League. For three consecutive seasons from 2013–14 to 2015–16, he was elected as United's Sir Matt Busby Player of the Year, the first player in the award's history to win on three successive occasions (four in total), as well as being included in four consecutive (five in total) PFA Team of the Year sides from 2015 to 2018. In 2018, he was named in the FIFA FIFPro World11. De Gea left United as following the expiration of his contract in 2023, and, following a year away from football, joined Fiorentina.\r\n\r\nTipped by many as the successor to Iker Casillas as Spain's long-term goalkeeper, De Gea was the captain for the Spain under-21 national team that won the European Championship in 2011 and 2013, and also competed in the 2012 Summer Olympics. He made his debut for the senior team in 2014 and was selected for that year's World Cup. De Gea was named as Spain's starting goalkeeper for the 2016 European Championship and the 2018 FIFA World Cup, receiving criticism for his performance in the latter. He lost his regular place to Unai Simón for UEFA Euro 2020."
        , facebook: "www.facebook.com/DavidDeGeaOficial/?fref=ts"
        , website: ""
        , twitter: "twitter.com/D_DeGea"
        , instagram: "www.instagram.com/d_degeaofficial"
        , youtube: ""
        , height: "1.92 m (6 ft 4 in)", weight: "73.92"
        , strFanart1: "https://www.thesportsdb.com/images/media/player/fanart/wvuxrv1421054938.jpg"
        , strFanart2: "https://www.thesportsdb.com/images/media/player/fanart/wxyytq1421054944.jpg"
        , strFanart3: "https://www.thesportsdb.com/images/media/player/fanart/xtvvxu1421054950.jpg"
        , strFanart4: "https://www.thesportsdb.com/images/media/player/fanart/qtttyt1421054957.jpg")
}

extension PlayerViewModel {
    func searchPlayers() {
        Task {
            for playerName in listPlayerName {
                await searchAndAppendPlayer(by: playerName)
            }
        }
    }
    
   private func searchAndAppendPlayer(by playerName: String) async {
       await withCheckedContinuation { continuation in
           self.searchPlayer(by: playerName) { (result: Result<PlayerDetailResponse, Error>) in
               switch result {
               case .success(let data):
                   if let player = data.player, !player.isEmpty {
                       self.models.append(player[0])
                   }
               case .failure(_):
                   break
               }
               continuation.resume() // Resume the continuation after the async work
           }
       }
   }
    
    func fetch(by team: TeamModel) {
        DispatchQueueManager.share.runInBackground {
            self.getPlayers(from: team) { (result: Result<PlayerResponse, Error>) in
                switch result {
                case.success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.players ?? []
                    }
                case.failure(_):
                    DispatchQueueManager.share.runOnMain {
                        self.models = []
                    }
                }
            }
        }
    }
    
    func getPlayerDetail(by playerID: String, completiion: @escaping () -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getPlayerDetail(by: playerID) { (result: Result<PlayerResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.modelDetail = data.players?[0] ?? nil
                        completiion()
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        completiion()
                    }
                }
            }
        }
    }
    
    func setDetail(by player: PlayerModel) {
        self.modelDetail = player
    }
}


extension PlayerViewModel {
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func resetModels() {
        self.models = []
    }
    
    func resetAll() {
        self.models = []
        
        self.modelDetail = nil
    }
}
