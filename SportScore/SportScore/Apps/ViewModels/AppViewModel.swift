//
//  AppViewModel.swift
//  SportScore
//
//  Created by pc on 31/07/2024.
//

import Foundation
import SwiftUI

enum Page: String {
    case Main
    case Country
    case League
    case LeagueDetail
    case Team
    case TeamDetail
    case Player
    
    case NotiFy
    
    case EventDetail
}

extension Page {
    func getView() -> AnyView {
        switch self {
        case .Main:
            return AnyView(EmptyView())
        case .Country:
            return AnyView(CountryView())
        case .League:
            return AnyView(LeaguesView())
        case .LeagueDetail:
            return AnyView(LeagueDetailView())
        case .Team:
            return AnyView(TeamsView())
        case .Player:
            return AnyView(PlayerView())
        case .TeamDetail:
            return AnyView(TeamDetailView())
        case .NotiFy:
            return AnyView(NotificationView())
        case .EventDetail:
            return AnyView(EventDetailView())
        }
    }
    
    func getItemSelectedView() -> AnyView {
        switch self {
        case .Main:
            return AnyView(EmptyView())
        case .Country:
            return AnyView(CountryItemPageSelectedView())
        case .League:
            return AnyView(LeaguesItemPageSelectedView())
        case .LeagueDetail:
            return AnyView(LeagueDetailView())
        case .Team:
            return AnyView(TeamsView())
        case .Player:
            return AnyView(PlayerView())
        case .TeamDetail:
            return AnyView(TeamDetailView())
        case .NotiFy:
            return AnyView(NotificationView())
        case .EventDetail:
            return AnyView(EventDetailView())
        }
    }
}

struct LeaguesItemPageSelectedView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        LeaguesDetailView()
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        BadgeCloseView()
                            .frame(alignment: .topTrailing)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    UIApplication.shared.endEditing() // Dismiss the keyboard
                                    leaguesVM.resetDetail()
                                    teamVM.resetDetail()
                                    playerVM.resetDetail()
                                    appVM.switchPage(to: .League)
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
            .scaleEffect(0.85)
    }
}

struct CountryItemPageSelectedView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var appVM: AppViewModel
    
    var body: some View {
        CountryDetailView()
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        BadgeCloseView()
                            .frame(alignment: .topTrailing)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    UIApplication.shared.endEditing() // Dismiss the keyboard
                                    countryVM.resetDetail()
                                    leaguesVM.resetDetail()
                                    teamVM.resetDetail()
                                    playerVM.resetDetail()
                                    appVM.switchPage(to: .Country)
                                }
                            }
                    }
                    
                    Spacer()
                }
            }
            .scaleEffect(0.85)
    }
}


class AppViewModel: ObservableObject {
    @Published var textSearch: String = ""
    @Published var columns: [GridItem] = [GridItem(),GridItem(),GridItem()]
    
    @Published var showBlurMap: Bool = true
    
    @Published var page: Page = .Country
    @Published var pagesSelected: [Page] = []
    
    @Published var sizeImage: (width: CGFloat, height: CGFloat) = (width: 70.0, height: 70.0)
    
    
    @Published var showDialog: Bool = false
    @Published var titleDialog: String = ""
    @Published var titleButonAction: String = ""
    @Published var bodyDialog = AnyView(Text("This is my content"))
    @Published var loading: Bool = false
    
    func showDialogView(with title: String, and body: AnyView) {
        self.titleDialog = title
        self.bodyDialog = body
        self.showDialog = true
    }
    
    func showBlurView() {
        self.showBlurMap = true
    }
    
    func resetTextSearch() {
        self.textSearch = ""
    }
    
    func switchPage(to newPage: Page) {
        self.page = newPage
    }
}
