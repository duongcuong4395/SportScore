//
//  SportsPageViewModel.swift
//  SportScore
//
//  Created by pc on 02/09/2024.
//

import Foundation


class SportTypeViewModel: ObservableObject {
    @Published var selected: SportType = .Soccer
}


protocol SportSpecificPageHandling {
    func customAddPageLogic(page: SportPage)
    func customRemovePageLogic(page: SportPage)
}

class SportPageViewModel: ObservableObject {
    @Published var pages: [SportPage] = []
    @Published var pageSelected: SportPage = .Country
    
    // These methods are now part of the main class, allowing them to be overridden
    func customAddPageLogic(page: SportPage) {
       if !self.pages.contains(page) {
           self.pages.append(page)
           setCurrent(by: page.getCurrentPage() ?? page)
       }
    }

    func customRemovePageLogic(page: SportPage) {
       if let index = self.pages.firstIndex(of: page) {
           self.pages.removeSubrange(index..<self.pages.count)
           // setCurrent(by: pages.last ?? .Country)
           
           if self.pages.isEmpty {
               setCurrent(by: .Country)
           } else {
               guard let lastPage = self.pages.last
                       , let currPage = lastPage.getCurrentPage()
               else { return }
               
               self.setCurrent(by: currPage)
           }
       }
    }

    func add(_ page: SportPage) {
       // Custom logic can be applied here
       customAddPageLogic(page: page)
    }

    func setCurrent(by page: SportPage) {
       self.pageSelected = page
    }

    func removeFrom(_ page: SportPage) {
       // Custom logic can be applied here
       customRemovePageLogic(page: page)
    }
}

class SportsPageViewModel: SportPageViewModel {
    
    override func customAddPageLogic(page: SportPage) {
       super.customAddPageLogic(page: page)
    }

    override func customRemovePageLogic(page: SportPage) {
       super.customRemovePageLogic(page: page)
    }
}

