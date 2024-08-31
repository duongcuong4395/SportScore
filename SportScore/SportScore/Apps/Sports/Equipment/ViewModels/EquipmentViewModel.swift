//
//  EquipmentViewModel.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import Foundation


class EquipmentViewModel: ObservableObject, SportAPIEvent {
    @Published var models: [EquipmentModel] = []
    
    func fetch(from team: TeamModel, completion: @escaping () -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getLookupEquipment(from: team) { (result: Result<EquipmentResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.models = data.equipment ?? []
                        completion()
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        completion()
                    }
                }
            }
        }
        
    }
}
