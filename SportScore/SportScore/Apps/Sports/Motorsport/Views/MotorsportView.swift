//
//  MotorsportView.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import SwiftUI

struct MotorsportView: View {
    @StateObject var motorsportPageVM = MotorsportPageViewModel()
    
    var body: some View {
        SportView(pages: motorsportPageVM.pages, pageSelected: motorsportPageVM.pageSelected)
            .environmentObject(motorsportPageVM)
    }
}

