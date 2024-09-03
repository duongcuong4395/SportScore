//
//  LeaguesViewModel.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import Foundation

enum RequestAPIState {
    case Idle
    case Loading
    case Success
    case Fail
}

import SwiftUI

class LeaguesViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [LeaguesModel] = []
    @Published var modelDetail: LeaguesModel?
    
    @Published var modelsFilter: [LeaguesModel] = []
    
    @Published var requestAPIState: RequestAPIState = .Idle
    
    @Published var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    func fetch(from country: CountryModel, by sportType: String, completion: @escaping () -> Void) {
        self.requestAPIState = .Loading
        
        self.getLeagues(from: country, by: "") { objs in
            self.getLeagues(from: country, by: sportType) { objs2 in
                var res = objs + objs2
                res = res.filter({ $0.sportType?.rawValue == sportType})
                res = Array(Set(res))
                print("=== getLeagues", res)
                self.models = res
                
                //self.models = Array(Set(self.models))
                self.requestAPIState = .Success
            }
        }
    }
    
    func getLeagues(from country: CountryModel, by sportType: String, completion: @escaping ([LeaguesModel]) -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getLeagues(from: country, by: sportType) { (result: Result<LeaguesResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        guard let leagues = data.leagues else { completion([]); return }
                        completion(leagues)
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        completion([])
                    }
                }
            }
        }
    }
    
    
    func setDetail(by leagues: LeaguesModel) {
        self.modelDetail = leagues
    }
    
    func filter(by text: String) {
        let textSearch = text.lowercased()
        
        self.modelsFilter = textSearch.isEmpty ? self.models : self.models.filter {
            $0.leagueName?.lowercased().contains(textSearch) ?? false
        }
    }
    
    func getListEmptyModels() -> [LeaguesModel] {
        return [LeaguesModel(), LeaguesModel(), LeaguesModel()
                ,LeaguesModel(), LeaguesModel(), LeaguesModel()
                ,LeaguesModel(), LeaguesModel(), LeaguesModel()]
    }
}

extension LeaguesViewModel {
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func resetModels() {
        self.models = []
    }
    
    func resetAll() {
        self.models = []
        self.modelDetail = nil
        self.modelsFilter = []
    }
}


import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

// MARK: - For List View
extension LeaguesViewModel {
    
    @ViewBuilder
    func getTrophyView() -> some View {
        VStack {
            HStack {
                Text("Trophy:")
                    .font(.callout.bold())
                Spacer()
            }
            KFImage(URL(string: self.modelDetail?.trophy ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .fadeInEffect(duration: 1)
        }
    }
}
