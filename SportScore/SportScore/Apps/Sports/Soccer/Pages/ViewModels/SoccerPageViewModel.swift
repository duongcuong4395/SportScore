//
//  SoccerPageViewModel.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import Foundation

class SoccerPageViewModel: ObservableObject {
    @Published var pages: [SportPage] = []
    @Published var pageSelected: SportPage = .Country
    
    @Published var pagesAdded: [(id: UUID, page: SportPage?, currentPage: SportPage)] = [(UUID() ,nil, .Country)]
}

// MARK: - For New
extension SoccerPageViewModel {
    
    func getPage() {
        if pages.isEmpty {
            self.setCurrent(by: .Country)
        } else {
            guard let lastPage = pages.last else { return }
            switch lastPage {
            case .Country:
                self.setCurrent(by: .Leagues)
            case .Leagues:
                self.setCurrent(by: .Leagues)
            case .LeaguesDetail:
                self.setCurrent(by: .Leagues)
            case .Event:
                self.setCurrent(by: .Leagues)
            case .EventDetail:
                self.setCurrent(by: .Leagues)
            case .Team:
                self.setCurrent(by: .Leagues)
            case .TeamDetail:
                self.setCurrent(by: .Leagues)
            }
        }
    }
    
    func add(by page: SportPage) {
        if let index = self.pages.firstIndex(of: page)  {
            print("removePagesFrom.index:")
        } else {
            self.pages.append(page)
            guard let currPage = page.getCurrentPage() else { return }
            self.setCurrent(by: currPage)
        }
        
        print("=== ListPage.add:", self.pages)
    }
    
    
    func setCurrent(by page: SportPage) {
        self.pageSelected = page
    }
    
    func removeFrom(_ page: SportPage) {
        if let index = self.pages.firstIndex(of: page) {
            if index == 0 {
                self.pages.removeAll()
            } else {
                self.pages.removeSubrange(index..<self.pages.count)
                print("=== ListPage.Remove:", self.pages)
            }
        }
    }
    
    func setDefaultPage() {
        self.pageSelected = .Country
    }
}
