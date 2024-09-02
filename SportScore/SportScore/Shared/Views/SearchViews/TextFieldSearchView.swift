//
//  TextFieldSearchView.swift
//  SportScore
//
//  Created by pc on 31/07/2024.
//

import SwiftUI

struct TextFieldSearchView: View {
    @EnvironmentObject var appVM: AppViewModel
    
    @Environment(\.colorScheme) var appMode
    @State var listModels: [[Any]]
    //@Binding var textSearch: String

    @State var showClear: Bool = true
    
    var action: () -> Void
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyleItemView(by: appMode)
                .padding(.leading, 5)
            TextField("Enter country", text: $appVM.textSearch)
                .foregroundStyleItemView(by: appMode)
                
            if showClear {
                if !appVM.textSearch.isEmpty {
                    Button(action: {
                        self.appVM.textSearch = ""
                        for i in 0..<listModels.count {
                            listModels[i] = []
                        }
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    .foregroundStyleItemView(by: appMode)
                    .padding(.trailing, 5)
                }
            }
        }
        .padding(.vertical, 3)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 10, style: .continuous)
        )
        //.edgesIgnoringSafeArea(.bottom)
        .onChange(of: appVM.textSearch) { oldValue, newValue in
            action()
        }
    }
}


extension View {
    func foregroundStyleItemView(with appMode: ColorScheme) -> some View {
        self.foregroundStyle(appMode == .light ? .black : .white)
    }
    func foregroundStyleItemView(by appMode: ColorScheme) -> some View {
        self.foregroundStyle(appMode == .light ? .black : .white)
    }
}
