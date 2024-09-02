//
//  TeamViewModel.swift
//  SportScore
//
//  Created by pc on 11/08/2024.
//

import Foundation
import SwiftUI

class TeamViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [TeamModel] = []
    @Published var modelDetail: TeamModel?

    @Published var modelsFilter: [TeamModel] = []
    
    @Published var isLoading: Bool = false
    
    @Published var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    func fetch(from league: LeaguesModel) {
        self.isLoading = true
        DispatchQueueManager.share.runInBackground {
            self.getTeams(from: league) { (result: Result<TeamResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.teams ?? []
                        self.isLoading = false
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        self.isLoading = false
                    }
                }
            }
        }
        
    }
    
    func resetModels() {
        self.models = []
    }
    
    func resetDetail() {
        self.modelDetail = nil
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
        print("=== getTeam:", text, team?.teamName ?? "", team?.idTeam ?? "")
        return team
    }
    
    
    func getListEmptyModels() -> [TeamModel] {
        return [TeamModel(), TeamModel(), TeamModel()
                , TeamModel(), TeamModel(), TeamModel()
                , TeamModel(), TeamModel(), TeamModel()
                , TeamModel(), TeamModel(), TeamModel()]
    }
}
