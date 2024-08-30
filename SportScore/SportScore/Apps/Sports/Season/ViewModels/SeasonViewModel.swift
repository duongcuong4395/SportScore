//
//  SeasonViewModel.swift
//  SportScore
//
//  Created by pc on 20/08/2024.
//

import Foundation

class SeasonViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [SeasonModel] = []
    
    
    
    @Published var modelsRank: [RankModel] = []
    
    
    @Published var seasonSelected: SeasonModel?
    @Published var leagueSelected: LeaguesModel?
    
    @Published var showRanks = [Bool](repeating: false, count: 0)
    
    func getAllSeason(by league: LeaguesModel) {
        DispatchQueueManager.share.runInBackground {
            self.getSeason(from: league) { (result: Result<SeasonResponse, Error>) in
                switch result {
                case .success(let data):
                    print("== getSeason: \(league.idLeague ?? "") - \(league.leagueName ?? "")", data.seasons ?? [])
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.seasons ?? []
                    }
                case .failure(let err):
                    print("getSeason.error:", league.idLeague ?? "", league.leagueName ?? "", err)
                    DispatchQueueManager.share.runOnMain {
                        self.models = []
                    }
                }
                
            }
        }
        
    }
    
    func getTableRank(by league: LeaguesModel, and season: SeasonModel) {
        DispatchQueueManager.share.runInBackground {
            self.getLookuptable(from: league, and: season) { (result: Result<LookuptableResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = data.table ?? []
                    }
                case .failure(let err):
                    print("getSeason.error:", league.idLeague ?? "", season.season ?? "", league.leagueName ?? "", err)
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = []
                    }
                }
            }
        }
    }
    
    func getTableRank() {
        guard let league = leagueSelected else { return }
        guard let season = seasonSelected else { return }
        DispatchQueueManager.share.runInBackground {
            self.getLookuptable(from: league, and: season) { (result: Result<LookuptableResponse, Error>) in
                switch result {
                case .success(let data):
                    print("=== getLookuptable.success:", league.idLeague ?? "", season.season ?? "", league.leagueName ?? "", data.table?.count ?? 0)
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = data.table ?? []
                    }
                case .failure(let err):
                    print("=== getLookuptable.error:", league.idLeague ?? "", season.season ?? "", league.leagueName ?? "", err)
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = []
                    }
                }
            }
        }
    }
    
    
    func getTableRank(by league: LeaguesModel, and season: SeasonModel, for teamName: String) {
        
        DispatchQueueManager.share.runInBackground {
            self.getLookuptable(from: league, and: season) { (result: Result<LookuptableResponse, Error>) in
                switch result {
                case .success(let data):
                    print("==== getLookuptable.success:", league.idLeague ?? "", season.season ?? "", league.leagueName ?? "", data.table?.count ?? 0)
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = data.table?.filter {
                            ($0.teamName ?? "").contains(teamName)
                            && $0.intRank == "1"
                        } ?? []
                    }
                case .failure(let err):
                    print("==== getLookuptable.error:", league.idLeague ?? "", season.season ?? "", league.leagueName ?? "", err)
                    DispatchQueueManager.share.runOnMain {
                        self.modelsRank = []
                    }
                    
                }
            }
            
        }
        
    }
}


extension SeasonViewModel {
    func setSeasonSelected(by season: SeasonModel) {
        self.seasonSelected = season
    }
    
    func resetSeasonSelected() {
        self.seasonSelected = nil
    }
    
    func setLeagueSelected(by league: LeaguesModel) {
        self.leagueSelected = league
    }
    
    func resetLeagueSelected() {
        self.leagueSelected = nil
    }
    
    func resetShowRank() {
        self.showRanks = [Bool](repeating: false, count: 0)
    }
    
    func resetModelRanks() {
        self.modelsRank = []
    }
}
