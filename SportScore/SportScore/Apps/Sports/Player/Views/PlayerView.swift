//
//  PlayerView.swift
//  SportScore
//
//  Created by pc on 11/08/2024.
//

import SwiftUI
import QGrid

struct PlayerView: View {
    @EnvironmentObject var playerVM: PlayerViewModel
    @State var selection: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection : $selection){
                ForEach(Array(playerVM.models.enumerated()), id: \.element.idPlayer) { index, player in
                    player.getView { EmptyView().toAnyView() }
                        //.padding(0)
                        .frame(width: UIScreen.main.bounds.width - 20)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                        
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(
                .page(backgroundDisplayMode: .never)
            )
        }
    }
}

