//
//  ScheduleViewModel.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import Foundation
import UserNotifications


class ScheduleViewModel: ObservableObject, SportAPIEvent {
    let notifyCenter = UNUserNotificationCenter.current()
    @Published var models: [ScheduleLeagueModel] = []
    
    @Published var modelsForNext: [ScheduleLeagueModel] = []
    @Published var modelsForPrevious: [ScheduleLeagueModel] = []
    @Published var modelsForLastEvents: [ScheduleLeagueModel] = []
    
    @Published var modelDetail: ScheduleLeagueModel?
    
    func fetch(from league: LeaguesModel, for nextOrPrevious: NextAndPrevious
               , from context: NSManagedObjectContext
               , completion: @escaping (Bool) -> Void
    ) {
        DispatchQueueManager.share.runInBackground {
            self.getSchedule(from: league, for: nextOrPrevious) { [weak self] (result: Result<ScheduleLeagueResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        if nextOrPrevious == .Next {
                            self?.modelsForNext = data.scheduleLeagues ?? []
                        } else {
                            self?.modelsForPrevious = data.scheduleLeagues ?? []
                        }
                        completion(true)
                    }
                case .failure(let err):
                    //
                    DispatchQueueManager.share.runOnMain {
                        self?.modelsForNext = []
                        self?.modelsForPrevious = []
                        print("getSchedule.error: - \(nextOrPrevious.rawValue)", err)
                        completion(false)
                    }
                }
            }
        }
        
    }
    
    func fetch(by teamID: Int, for nextOrPrevious: NextAndPrevious
               , from context: NSManagedObjectContext
    ) {
        DispatchQueueManager.share.runInBackground {
            self.getSchedule(by: teamID, for: nextOrPrevious) { [weak self] (result: Result<ScheduleLeagueResponse, Error>) in
                switch result {
                case .success(let data):
                    DispatchQueueManager.share.runOnMain {
                        if nextOrPrevious == .Next {
                            self?.modelsForNext = data.scheduleLeagues ?? []
                        } else {
                            self?.modelsForPrevious = data.scheduleLeagues ?? []
                        }
                    }
                case .failure(let err):
                    DispatchQueueManager.share.runOnMain {
                        self?.modelsForNext = []
                        self?.modelsForPrevious = []
                    }
                    print("getSchedule.error: - \(nextOrPrevious.rawValue)", err)
                }
            }
        }
        
    }
    
    func getLastEvents(by teamID: String) {
        DispatchQueueManager.share.runInBackground {
            self.getLastEvent(by: teamID) { (result: Result<LastEventsResponse, Error>) in
                switch result {
                case .success(var data):
                    DispatchQueueManager.share.runOnMain {
                        self.modelsForLastEvents = data.results ?? []
                    }
                case .failure(_):
                    DispatchQueueManager.share.runOnMain {
                        self.modelsForLastEvents = []
                    }
                }
            }
        }
        
    }
    
    
    
    
    func updateIsFavoriteStatus(from context: NSManagedObjectContext) {
        let allModels = modelsForNext + modelsForPrevious
        let ids = allModels.compactMap { $0.idEvent }
        
        let fetchRequest: NSFetchRequest<ScheduleCD> = ScheduleCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idEvent IN %@", ids)
        
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            let favoritesDict = Dictionary(uniqueKeysWithValues: fetchedResults.map { ($0.idEvent ?? "", $0.isFavorite) })
            
            for i in 0..<modelsForNext.count {
                if let id = modelsForNext[i].idEvent, let isFavorite = favoritesDict[id] {
                    modelsForNext[i].isFavorite = isFavorite
                }
            }
            
            for i in 0..<modelsForPrevious.count {
                if let id = modelsForPrevious[i].idEvent, let isFavorite = favoritesDict[id] {
                    modelsForPrevious[i].isFavorite = isFavorite
                }
            }
            
            self.objectWillChange.send()
        } catch {
            print("Failed to fetch ScheduleCD objects: \(error)")
        }
    }
    
    func updateIsNotifyStatus() {
        self.notifyCenter.getPendingNotificationRequests { [weak self] notifications in
            guard let self = self else { return }
            
            let notificationIds = notifications.compactMap { notification -> String? in
                return notification.content.userInfo["idEvent"] as? String
            }
            updateModelsNotifyStatus(for: &self.modelsForNext, notificationIds: notificationIds)
            updateModelsNotifyStatus(for: &self.modelsForPrevious, notificationIds: notificationIds)
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private func updateModelsNotifyStatus(for models: inout [ScheduleLeagueModel], notificationIds: [String]) {
        for i in 0..<models.count {
            if let id = models[i].idEvent {
                models[i].isNotify = notificationIds.contains(id)
            }
        }
    }
}

extension ScheduleViewModel {
    func resetModels() {
        self.modelsForNext = []
        self.modelsForPrevious = []
    }
    
    func resetAll() {
        self.models = []
        self.modelsForNext = []
        self.modelsForPrevious = []
        self.modelsForLastEvents = []
        
        self.modelDetail = nil
    }
}

extension ScheduleViewModel {
    func setModelDetail(by model: ScheduleLeagueModel) {
        self.modelDetail = model
    }
}

import CoreData

extension ScheduleViewModel {
    
    func checkExistsCoreData(of model: ScheduleLeagueModel
                             , from context: NSManagedObjectContext
                             , completion: @escaping (Bool, ScheduleCD?) -> Void
    ) {
        try? model.checkExists(in: context) { exists, objs in
            DispatchQueue.main.async {
                completion(objs.count > 0
                           , objs.count > 0 ? objs[0] as? ScheduleCD : nil)
            }
            
        }
    }
}

// MARK: - For Favorite
extension ScheduleViewModel {
    func toggleFavoriteModel(for model: ScheduleLeagueModel
                             , by isFavorite: Bool) {
        print("== toggleFavoriteModel", isFavorite, model)
        DispatchQueue.main.async {
            
            if let id = self.modelsForNext.firstIndex(where: { $0.idEvent == model.idEvent }) {
                print("toggleLikeModel.Next", id, isFavorite)
                self.modelsForNext[id].isFavorite = isFavorite
            } else {
                guard let id = self.modelsForPrevious.firstIndex(where: { $0.idEvent == model.idEvent }) else { return }
                
                print("toggleLikeModel Previous", id, isFavorite)
                self.modelsForPrevious[id].isFavorite = isFavorite
            }
        }
    }
    
    func toggleFavoriteCoreData(for model: ScheduleLeagueModel
                                ,from context: NSManagedObjectContext
                                , completion: @escaping (Bool) -> Void) {
        
        self.checkFavorite(of: model, from: context, completion: { exists, obj in
            guard let obj = obj else {
                var newModel = model
                newModel.isFavorite = true
                newModel.add(into: context) { (result: Result<Bool, Error>) in
                    self.toggleFavoriteModel(for: newModel, by: true)
                }
                completion(true)
                return
            }
            obj.isFavorite.toggle()
            try? context.save()
            self.toggleFavoriteModel(for: model, by: obj.isFavorite)
            completion(obj.isFavorite)
        })
    }
    
    func checkFavorite(of model: ScheduleLeagueModel
                       , from context: NSManagedObjectContext
                       , completion: @escaping (Bool, ScheduleCD?) -> Void) {
        checkExistsCoreData(of: model, from: context) { isExists, obj in
            guard let obj = obj else {
                completion(false, nil)
                return
            }
            completion(obj.isFavorite, obj)
        }
    }
    
    func checkFavorite(of model: ScheduleLeagueModel
                       , from context: NSManagedObjectContext
                       , completion: @escaping (Result<(Bool, ScheduleCD?), Error>) -> Void) {
        checkExistsCoreData(of: model, from: context) { isExists, obj in
            guard let obj = obj else {
                
                completion(.success((false, nil)))
                return
            }
            
            completion(.success((obj.isFavorite, obj)))
        }
    }
    
    
    func updateCoreData(from objs: [ScheduleLeagueModel]
                        , from context: NSManagedObjectContext) {
        
    }
}

// MARK: - For Notify
extension ScheduleViewModel {
    func toggleNotifyModel(for model: ScheduleLeagueModel
                             , by isNotify: Bool) {
        DispatchQueue.main.async {
            
            if let id = self.modelsForNext.firstIndex(where: { $0.idEvent == model.idEvent }) {
                print("toggleLikeModel.Next", id, isNotify)
                self.modelsForNext[id].isNotify = isNotify
            } else {
                guard let id = self.modelsForPrevious.firstIndex(where: { $0.idEvent == model.idEvent }) else { return }
                print("toggleLikeModel Previous", id, isNotify)
                self.modelsForPrevious[id].isNotify = isNotify
            }
        }
    }
    
    func toggleNotifyCoreData(for model: ScheduleLeagueModel
                                , from context: NSManagedObjectContext
                              , completion: @escaping (Bool) -> Void) {
        self.checkNotify(of: model, from: context, completion: { exists, obj in
            guard let obj = obj else {
                var newModel = model
                newModel.isNotify = true
                newModel.add(into: context) { (result: Result<Bool, Error>) in
                    self.toggleNotifyModel(for: newModel, by: true)
                }
                completion(true)
                return
            }
            obj.isNotify.toggle()
            try? context.save()
            self.toggleNotifyModel(for: model, by: obj.isNotify)
            completion(obj.isNotify)
        })
    }
    
    
    
    func removeNotify(from eventID: String, from context: NSManagedObjectContext) {
        
        DispatchQueue.main.async {
            var model = ScheduleLeagueModel()
            model.idEvent = eventID
            self.toggleNotifyModel(for: model, by: false)
            self.checkNotify(of: model, from: context, completion: { exists, obj in
                guard let obj = obj else { return }
                model.removeItem(by: obj, into: context)
            })
        }
        
    }
    
    
    func checkNotify(of model: ScheduleLeagueModel
                       , from context: NSManagedObjectContext
                       , completion: @escaping (Bool, ScheduleCD?) -> Void) {
        checkExistsCoreData(of: model, from: context) { isExists, obj in
            guard let obj = obj else {
                completion(false, nil)
                return
            }
            completion(obj.isNotify, obj)
        }
    }
}




import SwiftUI

// MARK: - List View
extension ScheduleViewModel {
    
    @ViewBuilder
    func getEventsOfPreviousAndNextDayView() -> some View {
        if self.modelsForNext.count > 0 || self.modelsForPrevious.count > 0 {
            VStack {
                if self.modelsForNext.count > 0 {
                    Text("Upcoming")
                        .font(.callout.bold())
                    SoccerScheduleListItemView(models: self.modelsForNext)
                }
                if self.modelsForPrevious.count > 0 {
                    Text("Results")
                        .font(.callout.bold())
                    SoccerScheduleListItemView(models: self.modelsForPrevious)
                }
            }
        }
    }
}
