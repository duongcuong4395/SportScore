//
//  NotificationView.swift
//  SportScore
//
//  Created by pc on 13/08/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct NotificationView: View {
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.managedObjectContext) var context
    
    @State private var scheduleDate = Date()
    
    var body: some View {
        VStack {
            // MARK: - List view here
            List {
                ForEach(lnManager.pendingRequests, id: \.identifier) { request in
                    VStack(alignment: .leading) {
                        HStack {
                            if let timestamp = request.content.userInfo["timestamp"] as? String {
                                //Text(request.content.title)
                                Text(AppUtility.formatDate(from: timestamp, to: "dd/MM hh:mm") ?? "")
                                    .font(.caption.bold())
                            }
                        }
                        if let eventName = request.content.userInfo["eventName"] as? String {
                            Text(eventName)
                                .font(.callout.bold())
                        }
                        
                        if let banner = request.content.userInfo["banner"] as? String {
                            KFImage(URL(string: banner))
                                .placeholder { progress in
                                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width/1.5, height: 50)
                        }
                    }
                    .swipeActions {
                        Button("Delete", role: .destructive) {
                            withAnimation {
                                lnManager.removeRequest(with: request.identifier)
                                if let idEvent = request.content.userInfo["idEvent"] as? String {
                                    scheduleVM.removeNotify(from: idEvent, from: context)
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
        
        .task {
            try? await lnManager.requestAuthorization()
        }
        
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .active {
                Task {
                    await lnManager.getCurrentSetting()
                    await lnManager.getPendingRequests()
                }
            }
        }
        
    }
    
    @ViewBuilder
    func getItemView() -> some View{}
}




import UserNotifications

struct NotificationBellView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            Image(systemName: "heart")
                .font(.callout.bold())
                
                .overlay(content: {
                    NotificationCountView(value: .constant(favoriteVM.number))
                })
                .onTapGesture {
                    //favoriteVM.getObjsFavorite(of: ScheduleCD.self, sportype: .Soccer, from: context)
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    appVM.showDialogView(with: "Favorite"
                                         , and: FavoriteListItemView()
                        .frame(height: UIScreen.main.bounds.height/2)
                        .toAnyView()
                        )
                    _ = favoriteVM.getObjs(of: sportTypeVM.selected, from: context)
                    
                }
                .padding()
            Image(systemName: "bell")
                .font(.callout.bold())
                .overlay(content: {
                    NotificationCountView(value: .constant(lnManager.pendingRequests.count))
                })
                .onTapGesture {
                    //appVM.switchPage(to: .NotiFy)
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    Task {
                        await lnManager.getPendingRequests()
                        appVM.showDialogView(with: "Notifications"
                                             , and: NotificationView()
                            //.environmentObject(lnManager)
                            .frame(height: UIScreen.main.bounds.height/3)
                            .toAnyView()
                            )
                    }
                    
                    
                    
                }
                .padding()
                
        }
    }
}
