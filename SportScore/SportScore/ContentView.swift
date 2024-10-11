//
//  ContentView.swift
//  SportScore
//
//  Created by pc on 25/07/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var mapVM = MapViewModel()
    @StateObject var markerVM = MarkerViewModel()
    @StateObject var appVM = AppViewModel()
    @StateObject var polylineVM = PolylineViewModel()
    @StateObject var lnManager = LocalNotificationManager()
    @StateObject var sportCoreDataManage = SportCoreDataManage()
    @StateObject var scheduleVM = ScheduleViewModel()
    
    @StateObject var favoriteVM = FavoriteViewModel()
    
    @StateObject var eventVM = EventViewModel()
    
    
    
    
    @StateObject var countryVM = CountryViewModel()
    @StateObject var leaguesVM = LeaguesViewModel(leagueRepository: RemoteLeagueRepository(sportAPI: LeaguesSportAPIEvent()))
    @StateObject var teamVM = TeamViewModel()
    @StateObject var playerVM = PlayerViewModel()
    
    @StateObject var equipmentVM = EquipmentViewModel()
    @StateObject var sportsPageVM = SportsPageViewModel()
    @StateObject var sportTypeVM = SportTypeViewModel()
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some View {
        ZStack {
            if isFirstLaunch {
                OnboardingView(isFirstLaunch: $isFirstLaunch)
            } else {
                //MapView()
                MainView()
                GetDialogView()
            }
        }
        .environmentObject(mapVM)
        .environmentObject(markerVM)
        .environmentObject(polylineVM)
        .environmentObject(appVM)
        .environmentObject(lnManager)
        
        .environmentObject(scheduleVM)
        .environmentObject(countryVM)
        .environmentObject(leaguesVM)
        .environmentObject(teamVM)
        .environmentObject(playerVM)
        .environmentObject(equipmentVM)
        
        .environmentObject(favoriteVM)
        .environmentObject(eventVM)
        .environmentObject(sportTypeVM)
        .environmentObject(sportsPageVM)
        
        .environment(\.managedObjectContext, sportCoreDataManage.container.viewContext)
        .onAppear{
            countryVM.fetchCountry { objs in
                //markerVM.addListMarker(from: objs)
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
    
    
}


extension ContentView {
    @ViewBuilder
    func GetDialogView() -> some View {
        if appVM.showDialog {
            ZStack {
                Color(.black)
                    .opacity(0.1)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        // appVM.showDialog.toggle()
                    }
                
                CustomDialogView(title: appVM.titleDialog, buttonTitle: appVM.titleButonAction, action: {
                    withAnimation{
                        appVM.showDialog = false
                    }
                }, content: appVM.bodyDialog)
            }
            .zIndex(9)
            .onAppear {
                if appVM.autoCloseView {
                    Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                        withAnimation(.easeInOut(duration: 1)) {
                            appVM.showDialog = false
                        }
                    }
                }
            }
        }
    }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

struct CustomDialogView: View {
    @EnvironmentObject var appVM : AppViewModel
    
    let title: String
    let buttonTitle: String
    let action: () -> ()
    var content: AnyView
    
    @State private var offset: CGFloat = 1000
    
    var body: some View {
        ZStack {
            
            VStack {
                //Spacer()
                VStack {
                    if title != "" {
                        Text(title)
                            .font(.system(size: 18))
                            .bold()
                        Divider()
                    }
                    content
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .background(.ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                action()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            })
                            .tint(.black)
                        }
                        
                        
                        Spacer()
                    }
                    .padding()
                    
                }
                .shadow(radius: 20)
                //.padding(30)
                .padding(.horizontal, 10)
                .padding(.bottom, 50)
                .offset(x: 0, y: offset)
                .onAppear{
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
    }
    
    func close() {
        withAnimation(.spring()) {
            self.offset = 1000
        }
    }
}




