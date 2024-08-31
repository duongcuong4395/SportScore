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
    
    func fetch(from country: CountryModel, by sportType: SportType, completion: @escaping () -> Void) {
        self.requestAPIState = .Loading
        DispatchQueueManager.share.runInBackground {
            self.getLeagues(from: country, by: sportType) { (result: Result<LeaguesResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.leagues?.filter({ $0.sportType == sportType}) ?? []
                        self.requestAPIState = .Success
                        completion()
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        self.requestAPIState = .Fail
                        completion()
                    }
                }
            }
        }
        
    }
    
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func resetModels() {
        self.models = []
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
                //.revealEffect(duration: 0.2, direction: .bottomToTop)
                //.rotateOnAppear(axis: .y)
                .fadeInEffect(duration: 1)
        }
    }
}
