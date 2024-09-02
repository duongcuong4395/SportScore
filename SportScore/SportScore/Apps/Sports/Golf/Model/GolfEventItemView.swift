//
//  GolfEventItemView.swift
//  SportScore
//
//  Created by pc on 02/09/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct GolfEventItemView: View {
    @Environment(\.managedObjectContext) var context
    
    
    @EnvironmentObject var sportsPageVM: SportsPageViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    @EnvironmentObject var lnManager: LocalNotificationManager
    @EnvironmentObject var teamVM: TeamViewModel
    @EnvironmentObject var playerVM: PlayerViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    var model: ScheduleLeagueModel
    var optionView: AnyView
    
    var body: some View {
        VStack {
            // MARK: - Date Time
            HStack {
                HStack {
                    Text(AppUtility.formatDate(from: model.timestamp, to: "dd/MM") ?? "")
                        //.font(.caption2)
                    Text(model.roundNumber ?? "")
                        //.font(.caption2.bold())
                    Text(AppUtility.formatDate(from: model.timestamp, to: "hh:mm") ?? "")
                        //.font(.caption2.bold())
                }
                .font(.caption2)
                .padding(5)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                
                Spacer()
                
                optionView
            }
            .padding(.leading, 40)
            .padding(.trailing, 10)
            
            
            HStack {
                // MARK: - Main Match Infor
                Text(model.eventName ?? "")
                    .font(.caption.bold())
                    .lineLimit(2)
                    .onTapGesture {
                        print("ScheduleMoto:")
                    }
                Spacer()
            }
            .padding(5)
            .padding(.vertical, 5)
            .padding(.leading, 20)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.trailing, 10)
            .padding(.leading, 20)
            
        }
        .overlay {
            HStack {
                KFImage(URL(string: sportTypeVM.selected.getImageUrl()))
                    .placeholder({ progress in
                        LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                    })
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30, height: 30)
                    .shadow(color: Color.yellow, radius: 3, x: 0, y: 0)
                    .padding(.leading, 5)
                    .offset(y: -10)
                    //.background(.ultraThinMaterial, in: Circle())
                    //.padding(.leading, 5)
                Spacer()
            }
            
        }
        .background{
            KFImage(URL(string: model.banner ?? ""))
                .resizable()
                .scaledToFill()
                .opacity(0.15)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onTapGesture {
                    eventVM.fetch(by: model.idEvent ?? "") { players in
                        if players.count > 0 {
                            scheduleVM.setModelDetail(by: model)
                            sportsPageVM.add(.Event)
                        }
                    }
                    
                }
            
        }
    }
}
