//
//  MotorsportEventItemMenuView.swift
//  SportScore
//
//  Created by pc on 26/08/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct MotorsportEventItemMenuView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    @EnvironmentObject var motorsportPageVM: MotorsportPageViewModel
    
    
    var body: some View {
        VStack {
            if let model = scheduleVM.modelDetail {
                VStack {
                    KFImage(URL(string: model.square ?? ""))
                        .placeholder({ progress in
                            LoadingIndicator(animation: .circleBars, size: .small, speed: .normal)
                        })
                        .resizable()
                        .scaledToFill()
                        .frame(width: appVM.sizeImage.width, height: appVM.sizeImage.height)
                        .shadow(color: Color.blue, radius: 5, x: 0, y: 0)
                        
                    Text(model.eventName ?? "")
                        .font(.caption.bold())
                }
            }
        }
        .modifier(BadgeCloseItem(action: {
            withAnimation(.spring()) {
                UIApplication.shared.endEditing()
                motorsportPageVM.removeFrom(.Event)
            }
        }))
        .scaleEffect(0.85)
    }
}
