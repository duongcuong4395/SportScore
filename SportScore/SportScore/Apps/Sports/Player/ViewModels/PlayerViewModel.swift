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
    
    
    func fetch(by team: TeamModel) {
        DispatchQueueManager.share.runInBackground {
            self.getPlayers(from: team) { (result: Result<PlayerResponse, Error>) in
                switch result {
                case.success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.players ?? []
                    }
                case.failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        self.models = []
                    }
                    
                    print("getPlayers.error", team.idTeam ?? "", team.teamName ?? "", err)
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
                case .failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        completiion()
                    }
                }
            }
        }
        
    }
    
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func setDetail(by player: PlayerModel) {
        self.modelDetail = player
    }
    
    func resetModels() {
        self.models = []
    }
}
