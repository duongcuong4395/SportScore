//
//  FightingPageViewModel.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import Foundation


class FightingPageViewModel: ObservableObject {
    @Published var pages: [SportPage] = []
    @Published var pageSelected: SportPage = .Country
}

extension FightingPageViewModel {
    
    func add(by page: SportPage) {
        if self.pages.firstIndex(of: page) != nil  {
            
        } else {
            self.pages.append(page)
            guard let currPage = page.getCurrentPage() else { return }
            
            print("=== self.pages", self.pages)
            self.setCurrent(by: currPage)
            print("=== setCurrent", self.pageSelected)
        }
    }
    
    
    func setCurrent(by page: SportPage) {
        self.pageSelected = page
    }
    
    func removeFrom(_ page: SportPage) {
        if let index = self.pages.firstIndex(of: page) {
            if index == 0 {
                self.pages.removeAll()
                self.setCurrent(by: .Country)
            } else {
                self.pages.removeSubrange(index..<self.pages.count)
                guard let lastPage = self.pages.last
                        , let currPage = lastPage.getCurrentPage()
                else { return }
                
                self.setCurrent(by: currPage)
            }
        }
    }
    
    func setDefaultPage() {
        self.pageSelected = .Country
    }
}
