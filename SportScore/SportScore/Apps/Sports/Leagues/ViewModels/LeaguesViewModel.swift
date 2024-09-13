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

enum APIState<T: Decodable> {
    case idle
    case loading
    case success([T])
    case failure(Error)
}


protocol LeagueRepository {
    func fetchLeagues(for country: CountryModel, by sportType: String) async throws -> [LeaguesModel]
}

class RemoteLeagueRepository: LeagueRepository {
    private let sportAPI: SportAPIEvent
    
    init(sportAPI: SportAPIEvent) {
        self.sportAPI = sportAPI
    }
    
    func fetchLeagues(for country: CountryModel, by sportType: String) async throws -> [LeaguesModel] {
        let result: LeaguesResponse = try await sportAPI.getLeagues(from: country, by: sportType)
        return result.leagues ?? []
    }
}

class LeaguesSportAPIEvent: SportAPIEvent {}

import SwiftUI
class LeaguesViewModel: ObservableObject, SportAPIEvent {
    
    @Published var state: APIState<LeaguesModel> = .idle
    
    @Published var models: [LeaguesModel] = []
    @Published var modelDetail: LeaguesModel?
    @Published var modelsFilter: [LeaguesModel] = []
    @Published var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    private let leagueRepository: LeagueRepository
        
    @Published var leagueCounts: [String: Int] = [:] 
    
    init(leagueRepository: LeagueRepository) {
        self.leagueRepository = leagueRepository
    }
}

extension LeaguesViewModel {
    @MainActor
    func fetchLeagues(from country: CountryModel, by sportType: String) async {
        self.state = .loading
        
        do {
            let leagues1 = try await leagueRepository.fetchLeagues(for: country, by: "")
            let leagues2 = try await leagueRepository.fetchLeagues(for: country, by: sportType)
            var leagues = leagues1 + leagues2
            leagues = Array(Set(leagues))
            leagues = leagues.filter { $0.sportType?.rawValue == sportType }
            self.models = leagues.sorted { $0.leagueName ?? "" > $1.leagueName ?? "" }
            self.state = .success(self.models)
        } catch {
            DispatchQueue.main.async {
                self.state = .failure(error)
            }
        }
    }
    
    @MainActor
    func countLeagues2(from country: CountryModel, by sportType: String) async -> Int {
        let cacheKey = "\(country.fullName)_\(sportType)"
        
        // Check if the count is already cached
        if let cachedCount = leagueCounts[cacheKey] {
            return cachedCount
        }
        
        // If not cached, fetch and store the count
        do {
            let leagues1 = try await leagueRepository.fetchLeagues(for: country, by: "")
            let leagues2 = try await leagueRepository.fetchLeagues(for: country, by: sportType)
            var leagues = leagues1 + leagues2
            leagues = Array(Set(leagues))
            leagues = leagues.filter { $0.sportType?.rawValue == sportType }
            let totalCount = leagues.count
            
            // Cache the result
            DispatchQueue.main.async {
                self.leagueCounts[cacheKey] = totalCount
                
            }
            return totalCount
        } catch {
            
            return 0
        }
    }
    
    func countLeagues(from country: CountryModel, by sportType: String) async -> Int {
        do {
            let leagues1 = try await leagueRepository.fetchLeagues(for: country, by: "")
            let leagues2 = try await leagueRepository.fetchLeagues(for: country, by: sportType)
            return leagues1.count + leagues2.count
        } catch {
            return 0
        }
    }
}

extension LeaguesViewModel {
    func filterLeagues(by text: String) {
        let searchText = text.lowercased()
        if searchText.isEmpty {
            self.modelsFilter = self.models
        } else {
            self.modelsFilter = self.models.filter { $0.leagueName?.lowercased().contains(searchText) ?? false }
        }
    }
    
    func getListEmptyModels() -> [LeaguesModel] {
        let item = LeaguesModel(leagueName: "Manchester United", currentSeason: "2023-2024")
        return [item, item, item
                ,item, item, item
                ,item, item, item
                ,item, item, item
                ,item, item, item]
    }
}

extension LeaguesViewModel {
    func setDetail(by leagues: LeaguesModel) {
        self.modelDetail = leagues
    }
    
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
                    //LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                    
                    Image("trophy_symbol")
                        .resizable()
                        .scaledToFill()
                        .redacted(reason: .placeholder)
                        .shimmer()
                }
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                .fadeInEffect(duration: 1)
            
        }
        .padding(.horizontal, 10)
    }
}
