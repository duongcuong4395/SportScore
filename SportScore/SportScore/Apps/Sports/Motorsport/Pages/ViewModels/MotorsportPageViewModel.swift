//
//  MotorsportPageViewModel.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import Foundation

class MotorsportPageViewModel: ObservableObject {
    
    @Published var pages: [SportPage] = []
    @Published var pageSelected: SportPage = .Country
}

// MARK: - For New
extension MotorsportPageViewModel {
    func add(by page: SportPage) {
        if let index = self.pages.firstIndex(of: page)  {
            print("removePagesFrom.index:")
        } else {
            self.pages.append(page)
        }
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
            }
        }
    }
    
    func setDefaultPage() {
        self.pageSelected = .Country
    }
}
