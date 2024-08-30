//
//  MotorsportScheduleView.swift
//  SportScore
//
//  Created by pc on 23/08/2024.
//

import SwiftUI

struct MotorsportScheduleView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    var body: some View {
        VStack {
            if scheduleVM.modelsForNext.count > 0 {
                Text("Upcoming")
                    .font(.callout.bold())
                MotorsportScheduleListItemView(models: scheduleVM.modelsForNext)
            }
            if scheduleVM.modelsForPrevious.count > 0 {
                Text("Results")
                    .font(.callout.bold())
                MotorsportScheduleListItemView(models: scheduleVM.modelsForPrevious)
            }
        }
    }
}



struct MotorsportScheduleListItemView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    var models: [ScheduleLeagueModel]
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 15) {
                ForEach(models) { model in
                    MotorsportScheduleItemView(model: model)
                }
            }
        }
    }
}


struct MotorsportScheduleItemView: View, ItemDelegate {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @Environment(\.managedObjectContext) var context
    
    var model: ScheduleLeagueModel
    
    var body: some View {
        model.getItemView(and: optionsView)
            .onAppear{
                scheduleVM.checkNotify(of: model, from: context) { isNotify, objCoreData in
                    scheduleVM.toggleNotifyModel(for: model, by: isNotify)
                }
                
                scheduleVM.checkFavorite(of: model, from: context) { isFavorite, objCoreData in
                    scheduleVM.toggleFavoriteModel(for: model, by: isFavorite)
                }
            }
            
    }
    
    @ViewBuilder
    func optionsView() -> some View {
        HStack(spacing: 30) {
            
            
            let now = Date()
            if let dateTimeOfMatch = DateUtility.convertToDate(from: model.timestamp ?? "") {
                if now < dateTimeOfMatch {
                    model.getBtnNotify(with: self)
                }
            }
            
            if model.video?.isEmpty == false {
                model.getBtnOpenVideo(with: self)
            }
            model.getBtnFavorie(with: self)
        }
    }
    
    func toggleFavorite<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        scheduleVM.toggleFavoriteCoreData(for: model, from: context) {
            favoriteVM.getCount(from: sportTypeVM.selected.getEntities(), of: sportTypeVM.selected, from: context)
        }
        UIApplication.shared.endEditing() // Dismiss the keyboard
    }
    
    func toggleNotify<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        UIApplication.shared.endEditing() // Dismiss the keyboard
        
        if lnManager.isGranted {
            scheduleVM.toggleNotifyCoreData(for: model, from: context) { isNotify in
                if isNotify {
                    Task {
                        guard let scheduleDate = DateUtility.convertToDate(from: model.timestamp ?? "") else { return }
                        
                        let dataComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: scheduleDate)
                        
                        let notifyData: [AnyHashable: Any] = [
                            "idEvent": model.idEvent ?? "",
                            "eventName": model.eventName ?? "",
                            "sportType": model.sportName ?? "",
                            //"homeTeamName": model.homeTeamName ?? "",
                            //"awayTeamName": model.awayTeamName ?? "",
                            "idHomeTeam": model.idHomeTeam ?? "",
                            "idAwayTeam": model.idAwayTeam ?? "",
                            "banner": model.banner ?? "",
                            "timestamp": model.timestamp ?? ""
                        ]
                        
                        let notify = NotificationModel(id: model.idEvent ?? ""
                                                       , title: "Soccer match"
                                                        , body: model.eventName ?? ""
                                                        , datecomponents: dataComponent
                                                        , repeats: false
                                                       , moreData: notifyData)
                        await lnManager.schedule(by: notify)
                    }
                } else {
                    lnManager.removeRequest(with: model.idEvent ?? "")
                }
            }
        } else {
            lnManager.openSettings()
        }
    }
    func openPlayVideo<T>(for model: T) where T : Decodable {
        guard let model = model as? ScheduleLeagueModel else { return }
        print("model.video", model.video ?? "", model.idEvent ?? "", model.eventName ?? "")
        appVM.showDialogView(with: model.eventName ?? ""
                             , and: ScheduleVideoView(model: model).toAnyView())
    }
}
