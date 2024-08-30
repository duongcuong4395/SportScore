//
//  TeamDetailView.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import SwiftUI

struct TeamDetailView: View {
    @EnvironmentObject var scheduleVM: ScheduleViewModel
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScheduleView()
                    .frame(height: UIScreen.main.bounds.height / 1.5)
                HStack {
                    Text("Players")
                        .font(.callout.bold())
                }
                PlayerView()
                    .frame(height: UIScreen.main.bounds.height / 2)
                HStack {
                    Text("Equipments")
                        .font(.callout.bold())
                }
                EquipmentView()
            }
        }
    }
}
