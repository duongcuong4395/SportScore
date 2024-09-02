//
//  ScheduleView.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    var body: some View {
        VStack {
            if scheduleVM.modelsForNext.count > 0 {
                Text("Upcoming")
                    .font(.callout.bold())
                ScheduleListItemView(models: scheduleVM.modelsForNext)
            }
            if scheduleVM.modelsForPrevious.count > 0 {
                Text("Results")
                    .font(.callout.bold())
                ScheduleListItemView(models: scheduleVM.modelsForPrevious)
            }
        }
    }
}


struct ScheduleListItemView: View {
    @State var models: [ScheduleLeagueModel]
    @State private var showModels: [Bool] = []
    var body: some View {
        VStack {
            if models.count > 3 {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        ForEach(Array(models.enumerated()), id: \.element.id) { index, model in
                            ScheduleItemView(model: model)
                                .sequentiallyAnimating(isVisible: showModels.indices.contains(index) ?
                                                       $showModels[index] : .constant(false), delay: Double(index) * 0.2, direction: .leftToRight)
                                .onAppear{
                                    //.easeInOut(duration: 0.1)
                                    withAnimation {
                                        showModels[index] = true
                                    }
                                }
                                
                        }
                    }
                }
            } else {
                LazyVStack(spacing: 15) {
                    ForEach(Array(models.enumerated()), id: \.element.id) { index, model in
                        ScheduleItemView(model: model)
                            .sequentiallyAnimating(isVisible: showModels.indices.contains(index) ?
                                                   $showModels[index] : .constant(false), delay: Double(index) * 0.2, direction: .leftToRight)
                            .onAppear{
                                //.easeInOut(duration: 0.1)
                                withAnimation {
                                    showModels[index] = true
                                }
                            }
                            
                    }
                }
            }
        }
        
        
        
        .onAppear{
            withAnimation {
                if showModels.count != models.count {
                    self.showModels = Array(repeating: false, count: models.count)
                    /*
                    for index in models.indices {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showModels[index] = true
                            }
                        }
                    }
                    */
               }
            }
        }
    }
}


struct ScheduleItemView: View, ItemDelegate {
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

import SwiftfulLoadingIndicators

struct ScheduleVideoView: View {
    let model: ScheduleLeagueModel
    @State var isLoading: Bool = false
    var body: some View {
        VStack {
            if let url = URL(string: model.video ?? "") {
                WebView(url: url, showLoading: $isLoading)
                    .frame(height: UIScreen.main.bounds.height / 3)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .overlay {
                        if isLoading {
                            ZStack {
                                Color(.clear)
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                                
                                LoadingIndicator(animation: .circleBars, size: .medium, speed: .fast)
                            }
                        } else {
                            EmptyView()
                        }
                    }
            }
            
            else {
                
            }
        }
        
    }
}


struct ScheduleMenuItemView: View {
    let model: ScheduleLeagueModel
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
