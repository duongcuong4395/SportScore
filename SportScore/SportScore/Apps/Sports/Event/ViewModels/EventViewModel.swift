//
//  EventViewModel.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import Foundation


class EventViewModel: ObservableObject, SportAPIEvent {
    @Published var modelsPlayer: [PlayerEventModel] = []
    @Published var listEvent: [ScheduleLeagueModel] = []
    @Published var listEventInSpecific: [ScheduleLeagueModel] = []
    
    //@EnvironmentObject var eventVM: EventViewModel
    
    @Published var eventDetail: ScheduleLeagueModel?
    
    @Published var currentSeason: String = ""
    @Published var currentLeagueID: String = ""
    @Published var currentRound: Int = 1
    @Published var isNextRound: Bool = true
    
    
}

extension EventViewModel {
    func toggleFavoriteModel(for model: ScheduleLeagueModel
                             , by isFavorite: Bool) {
        DispatchQueue.main.async {
            if let id = self.listEvent.firstIndex(where: { $0.idEvent == model.idEvent }) {
                self.listEvent[id].isFavorite = isFavorite
            }
            
            guard let id = self.listEventInSpecific.firstIndex(where: { $0.idEvent == model.idEvent }) else { return }
            self.listEventInSpecific[id].isFavorite = isFavorite
        }
    }
    
    func toggleNotifyModel(for model: ScheduleLeagueModel
                             , by isNotify: Bool) {
        DispatchQueue.main.async {
            
            if let id = self.listEvent.firstIndex(where: { $0.idEvent == model.idEvent }) {
                self.listEvent[id].isNotify = isNotify
            }
            if let id = self.listEventInSpecific.firstIndex(where: { $0.idEvent == model.idEvent }) {
                self.listEventInSpecific[id].isNotify = isNotify
            }
        }
    }
}


extension EventViewModel {
    func fetch(by eventID: String, completion: @escaping ([PlayerEventModel]) -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getEventresults(by: eventID) { (result: Result<EventResponse, Error>) in
                switch result {
                case .success(let data):
                    print("getEventresults: \(eventID)", data.players?.count ?? [])
                    DispatchQueueManager.share.runOnMain {
                        self.modelsPlayer = data.players ?? []
                        completion(self.modelsPlayer)
                    }
                case .failure(let err):
                    print("getEventresults.error", err)
                    DispatchQueueManager.share.runOnMain {
                        completion([])
                    }
                }
            }
        }
    }
    
    /// Get List event of league into Round of season
    func getListEvent(by leagueID: String, in round: String, of season: String, completion: @escaping ([ScheduleLeagueModel], Bool) -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getListEvent(by: leagueID, in: round, of: season) { (result: Result<EventsResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.listEvent = data.events ?? []
                        print("data.events: ", data.events?.count ?? 0)
                        completion(self.listEvent, true)
                    }
                    
                case .failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        self.listEvent = []
                        completion(self.listEvent, false)
                    }
                    
                    print("getListEvent.error: leagueID:\(leagueID) - round: \(round) - season:\(season)", err)
                }
            }
        }
    }
    
    func getEventForNextRound() {
        DispatchQueueManager.share.runInBackground {
            self.getListEvent(by: self.currentLeagueID, in: "\(self.currentRound + 1)", of: self.currentSeason) { (result: Result<EventsResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        guard let events = data.events else {
                            self.isNextRound = false
                            return
                        }
                        self.isNextRound = events.count > 0 ? true : false
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        self.isNextRound = false
                    }
                }
            }
        }
    }
    
    func getEventsInSpecific(by leagueID: String, of season: String, completion: @escaping ([ScheduleLeagueModel], Bool) -> Void) {
        DispatchQueueManager.share.runInBackground {
            self.getEventsInSpecific(by: leagueID, of: season) { (result: Result<EventsResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        self.listEventInSpecific = data.events ?? []
                        completion(self.listEventInSpecific, true)
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        completion([], false)
                    }
                }
            }
        }
    }
}

