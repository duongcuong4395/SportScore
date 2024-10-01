//
//  AppViewModel.swift
//  SportScore
//
//  Created by pc on 31/07/2024.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var textSearch: String = ""
    @Published var columns: [GridItem] = [GridItem(),GridItem(),GridItem()]
    
    @Published var showBlurMap: Bool = true
    
    @Published var showMap: Bool = false
    
    @Published var sizeImage: (width: CGFloat, height: CGFloat) = (width: 70.0, height: 70.0)
    
    
    @Published var showDialog: Bool = false
    @Published var titleDialog: String = ""
    @Published var titleButonAction: String = ""
    @Published var bodyDialog = AnyView(Text("This is my content"))
    @Published var loading: Bool = false
    @Published var autoCloseView: Bool = false
    
    
    func showDialogView(with title: String, and body: AnyView, then autoCloseView: Bool = false) {
        self.titleDialog = title
        self.bodyDialog = body
        self.showDialog = true
        self.autoCloseView = autoCloseView
        
        
    }
    
    func showBlurView() {
        self.showBlurMap = true
    }
    
    func resetTextSearch() {
        self.textSearch = ""
    }
}
