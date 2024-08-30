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
    
    var body: some View {
        QGrid(playerVM.models, columns: 2
              , vPadding: 5, hPadding: 5) { player in
            player.getView(with: getOptionView)
                .padding(0)
                .onTapGesture {
                    UIApplication.shared.endEditing() // Dismiss the keyboard
                    print("Player:", player)
                }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}
