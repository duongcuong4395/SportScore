//
//  FavoriteView.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        Text("Hello, World!")
    }
}


struct FavoriteListItemView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        
        VStack {
            ScrollView(showsIndicators: false) {
                if let models = favoriteVM.objs as? [ScheduleCD] {
                    ForEach(models, id: \.idEvent) { schedule in
                        
                        ScheduleLeagueModelItemView(model: schedule.convertToModel(), optionView: AnyView(EmptyView()))
                            .padding(0)
                    }
                }
            }
        }
        .padding(0)
        .onAppear{
            //guard let models = favoriteVM.objs as? [ScheduleCD] else { return }
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}
