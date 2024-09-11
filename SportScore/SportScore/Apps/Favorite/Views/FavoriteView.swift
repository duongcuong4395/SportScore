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
            HStack {
                Spacer()
                if favoriteVM.objs.count > 0 {
                    Button(action: {
                        let model = ScheduleLeagueModel()
                        try? model.removeAllCoreData(by: "ScheduleCD", into: context) { (result: Result<Bool, Error>) in
                            switch result {
                            case .success(let success):
                                guard success else { return }
                                withAnimation {
                                    favoriteVM.removeAll()
                                }
                            case .failure(let error):
                                print("=== removeAllCoreData.error", error)
                            }
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundStyle(.red)
                    })
                    .padding(5)
                    .background(.ultraThinMaterial, in: Circle())
                }
                
            }
        }
        .padding(0)
    }
    
}
