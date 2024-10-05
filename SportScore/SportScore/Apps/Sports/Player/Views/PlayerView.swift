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
    
    @State private var offset: CGFloat = 0
    @State private var dragging: Bool = false
    
    var body: some View {
        CarouselView(
               items: playerVM.models.map { player in
                   player.getView { EmptyView().toAnyView() }
                       .cornerRadius(10)
                       .shadow(radius: 5)
               },
               spacing: 5,
               cardWidth: UIScreen.main.bounds.width,
               cardHeight: UIScreen.main.bounds.height / 2  - 20
           )
    }
}

