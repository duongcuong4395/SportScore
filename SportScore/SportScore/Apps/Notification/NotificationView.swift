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





struct FavoriteItemView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        Image(systemName: "heart")
            .font(.title2)
            .overlay(content: {
                NotificationCountView(value: .constant(favoriteVM.number))
            })
            .onTapGesture {
                UIApplication.shared.endEditing() // Dismiss the keyboard
                _ = favoriteVM.getObjs(of: sportTypeVM.selected, from: context)
                withAnimation {
                    appVM.switchPage(by: .Favorite)
                }
                
                /*
                appVM.showDialogView(with: "Favorite"
                                     , and: FavoriteListItemView()
                    .frame(height: UIScreen.main.bounds.height/2)
                    .toAnyView()
                    )
                _ = favoriteVM.getObjs(of: sportTypeVM.selected, from: context)
                */
            }
    }
}

struct NotifyItemView: View {
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var appVM: AppViewModel
    var body: some View {
        Image(systemName: "bell")
            .font(.title2)
            .overlay(content: {
                NotificationCountView(value: .constant(lnManager.pendingRequests.count))
            })
            .onTapGesture {
                UIApplication.shared.endEditing() // Dismiss the keyboard
                Task {
                    await lnManager.getPendingRequests()
                    appVM.showDialogView(with: "Notifications"
                                         , and: NotificationView()
                        .frame(height: UIScreen.main.bounds.height/3)
                        .toAnyView()
                        )
                }
            }
    }
}
