//
//  FavoriteView.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import SwiftUI

struct FavoriteListItemView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
        
        VStack {
            ScrollView(showsIndicators: false) {
                if let models = favoriteVM.objs as? [ScheduleCD] {
                    ForEach(models, id: \.idEvent) { schedule in
                        SportEventItemView(model: schedule.convertToModel(), optionView: EmptyView().toAnyView())
                            .padding(0)
                    }
                }
            }
        }
        .padding(0)
    }
    
}
