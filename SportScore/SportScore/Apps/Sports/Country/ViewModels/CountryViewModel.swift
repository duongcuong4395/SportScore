//
//  CountryViewModel.swift
//  SportScore
//
//  Created by pc on 10/08/2024.
//

import Foundation
import SwiftUI

class CountryViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [CountryModel] = []
    @Published var modelDetail: CountryModel?
    
    @Published var modelsFilter: [CountryModel] = []
    
    @Published var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    init() {
        // fetch()
    }
    
    func fetch() {
        DispatchQueueManager.share.runInBackground {
            self.getCountries { (result: Result<CountryResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.countries
                    }
                case .failure(let err):
                    print("getCountries.error", err)
                }
            }
        }
    }
    
    func setDetail(by country: CountryModel) {
        self.modelDetail = country
    }
    
    func resetFilter() {
        self.modelsFilter = []
    }
    
    func resetDetail() {
        self.modelDetail = nil
    }
    
    func resetModels() {
        self.models = []
    }
    
    func filter(by text: String) {
        if text.isEmpty {
            self.modelsFilter = []
        } else {
            let textSearch = text.lowercased()
            self.modelsFilter = self.models.filter {
                $0.fullName.lowercased().contains(textSearch)
            }
        }
        
    }
}
