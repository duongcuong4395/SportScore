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
    
    @Published var eventDetail: ScheduleLeagueModel?
    
    @Published var currentSeason: String = ""
    @Published var currentLeagueID: String = ""
    @Published var currentRound: Int = 1
    @Published var isNextRound: Bool = true
    
    func fetch(by eventID: String) {
        DispatchQueueManager.share.runInBackground {
            self.getEventresults(by: eventID) { (result: Result<EventResponse, Error>) in
                switch result {
                case .success(let data):
                    print("getEventresults: \(eventID)", data.players?.count ?? [])
                    DispatchQueueManager.share.runOnMain {
                        self.modelsPlayer = data.players ?? []
                    }
                case .failure(let err):
                    print("getEventresults.error", err)
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
                case .failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        self.isNextRound = false
                    }
                }
            }
        }
    }
}
