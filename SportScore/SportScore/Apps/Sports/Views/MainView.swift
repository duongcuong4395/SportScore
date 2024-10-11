//
//  MainView.swift
//  SportScore
//
//  Created by Macbook on 9/10/24.
//

import Foundation
import SwiftUI

struct MainView : View {
    @EnvironmentObject var markerVM: MarkerViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    @State var scale: CGFloat = 0.0
    
    var body: some View {
        VStack {
            HeaderView()
            .background(.ultraThinMaterial.opacity(0.01), in: RoundedRectangle(cornerRadius: 5, style: .continuous))
            .padding(.horizontal, 5)
            
            if !appVM.showMap {
                SportMainView()
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scale = appVM.showMap ? 0 : 1
                        }
                    }
                    .onDisappear{ scale = 0 }
            }
            Spacer()
            SportTypeView()
        }
        .background{
            if !appVM.showMap {
                ZStack {
                    sportTypeVM.selected.getFieldImage()
                        .resizable()
                        .frame(width: .infinity, height: .infinity)
                        .ignoresSafeArea(.all)
                    
                    Color(.clear)
                        .background(.ultraThinMaterial.opacity(0.85), in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        .ignoresSafeArea(.all)
                        
                }
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        scale = appVM.showMap ? 0 : 1
                    }
                }
                .onDisappear{
                    scale = 0
                }
            }
        }
    }
}
