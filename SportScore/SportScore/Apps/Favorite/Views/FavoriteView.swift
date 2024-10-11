//
//  FavoriteView.swift
//  SportScore
//
//  Created by pc on 16/08/2024.
//

import SwiftUI

struct FavoriteListItemView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "heart")
                    .font(.title3.bold())
                Text("Favorite")
                    .font(.title3.bold())
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
                                    appVM.switchPage(by: .Sport)
                                }
                            case .failure(let error):
                                print("=== removeAllCoreData.error", error)
                            }
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .font(.title3)
                            .foregroundStyle(.red)
                    })
                    .padding(5)
                    .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal, 10)
            
            ScrollView(showsIndicators: false) {
                if let models = favoriteVM.objs as? [ScheduleCD] {
                    LazyVStack(spacing: 15) {
                        ForEach(models, id: \.idEvent) { schedule in
                            SportEventItemView(model: schedule.convertToModel(), optionView: EmptyView().toAnyView())
                                .padding(0)
                        }
                    }
                    .padding(5)
                }
            }
            /*
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
            */
        }
        .padding(0)
    }
    
}
