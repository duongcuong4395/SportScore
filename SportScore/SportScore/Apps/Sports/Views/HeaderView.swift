//
//  HeaderView.swift
//  SportScore
//
//  Created by Macbook on 9/10/24.
//

import Foundation
import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var markerVM: MarkerViewModel
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var mapVM: MapViewModel
    
    var body: some View {
        HStack {
            if appVM.page != .Sport {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .onTapGesture {
                        withAnimation {
                            appVM.page = .Sport
                        }
                    }
                Text("Back")
                    .font(.title3)
                    .onTapGesture {
                        withAnimation {
                            appVM.page = .Sport
                        }
                    }
            }
            TextFieldSearchView(listModels: []) {
                withAnimation(.spring()) {
                    markerVM.clearAll()
                    countryVM.filter(by: appVM.textSearch) { objs in
                        if objs.count > 0 {
                            if appVM.showMap {
                                let mid: Int = objs.count / 2
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    markerVM.addListMarker(from: objs)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    mapVM.moveTo(coordinate: objs[mid].coordinate, zoom: 150)
                                }
                            }
                        }
                    }
                }
            }
            HStack {
                FavoriteItemView()
                    .padding()
                NotifyItemView()
                    .padding()
            }
        }
    }
}
