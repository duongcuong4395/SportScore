//
//  LeagueDetailView.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import SwiftUI

struct LeagueDetailView: View {
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var leagueVM: LeaguesViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                if scheduleVM.modelsForNext.count > 0  || scheduleVM.modelsForPrevious.count > 0 {
                    ScheduleView()
                        .frame(height: UIScreen.main.bounds.height / 1.5)
                }
                
                if teamVM.models.count > 0 {
                    HStack {
                        Text("Teams")
                            .font(.callout.bold())
                    }
                    //TeamsView()
                        //.frame(height: UIScreen.main.bounds.height / 2)
                }
                LeagueDetailInforView()
            }
        }
    }
}

import Kingfisher
import SwiftfulLoadingIndicators

struct LeagueDetailInforView: View {
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("Trophy:")
                    .font(.callout.bold())
                Spacer()
            }
            KFImage(URL(string: leaguesVM.modelDetail?.trophy ?? ""))
                .placeholder { progress in
                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                }
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
            HStack {
                Text("Description:")
                    .font(.callout.bold())
                Spacer()
            }
            Text(leaguesVM.modelDetail?.descriptionEN ?? "")
                .lineLimit(nil)
                .frame(alignment: .leading)
            
        }
    }
    
    @ViewBuilder
    func getOptionView() -> some View {}
}



