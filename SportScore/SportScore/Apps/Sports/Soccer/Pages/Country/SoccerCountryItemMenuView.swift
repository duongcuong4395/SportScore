//
//  SoccerCountryItemMenuView.swift
//  SportScore
//
//  Created by pc on 18/08/2024.
//

import SwiftUI

struct SoccerCountryItemMenuView: View {
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var soccerPageVM: SoccerPageViewModel
    var body: some View {
        CountryItemMenuView()
            .modifier(BadgeCloseItem(action: {
                
                withAnimation(.spring()) {
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    //soccerPageVM.setCurrentPage(by: .Country)
                    soccerPageVM.setCurrent(by: .Country)
                    soccerPageVM.removeFrom(.Country)
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)  {}
                }
            }))
            .scaleEffect(0.85)
    }
}

struct BadgeCloseItem: ViewModifier {
    var action: () -> Void
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        BadgeCloseView()
                            .frame(alignment: .topTrailing)
                            .onTapGesture {
                                action()
                            }
                    }
                    Spacer()
                }
            }
    }
}
