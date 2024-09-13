//
//  TeamViewModel.swift
//  SportScore
//
//  Created by pc on 11/08/2024.
//

import Foundation
import SwiftUI

class TeamViewModel: ObservableObject, SportAPIEvent {
    
    @Published var apiState: APIState<TeamModel> = .idle
    @Published var models: [TeamModel] = []
    @Published var modelDetail: TeamModel?
    @Published var modelsFilter: [TeamModel] = []
    
    @Published var isLoading: Bool = false
    
    @Published var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    func fetch(from league: LeaguesModel) {
        self.isLoading = true
        self.apiState = .loading
        DispatchQueueManager.share.runInBackground {
            self.getTeams(from: league) { (result: Result<TeamResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.teams ?? []
                        self.isLoading = false
                        self.apiState = .success(self.models)
                    }
                case .failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        self.isLoading = false
                        self.apiState = .failure(err)
                    }
                }
            }
        }
    }
    
    func setDetail(by team: TeamModel) {
        self.modelDetail = team
    }
    
    func filter(by text: String) {
        let textSearch = text.lowercased()
        
        self.modelsFilter = textSearch.isEmpty ? self.models : self.models.filter {
            $0.teamName.lowercased().contains(textSearch)
        }
    }
    
    func getTeam(by text: String) -> TeamModel? {
        let team = models.first { team in
            team.idTeam == text || team.teamName == text
        }
        print("=== getTeam:", text, team?.teamName ?? "empty Team Name", team?.idTeam ?? "empty Team id")
        return team
    }
    
    func getTeamDetail(by teamName: String, completion: @escaping (TeamModel?) -> Void) {
        self.getTeamDetail(by: teamName) { (result: Result<TeamResponse, Error>) in
            switch result {
            case .success(let data):
                completion(data.teams?[0] ?? nil)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func getListEmptyModels() -> [TeamModel] {
        return [TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United")
                ,TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United")
                ,TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United")
                ,TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United")
                ,TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United"), TeamModel(teamName: "Manchester United")]
    }
}


extension TeamViewModel {
    func resetModels() {
        self.models = []
    }
    
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func resetAll() {
        self.models = []
        self.modelDetail = nil
        self.modelsFilter = []
    }
}
