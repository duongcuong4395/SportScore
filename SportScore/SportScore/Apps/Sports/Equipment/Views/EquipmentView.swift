//
//  EquipmentView.swift
//  SportScore
//
//  Created by pc on 12/08/2024.
//

import SwiftUI

struct EquipmentView: View {
    var body: some View {
        EquipmentListItemView()
    }
}


struct EquipmentListItemView: View {
    @EnvironmentObject var equipmentVM: EquipmentViewModel
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(equipmentVM.models) { equipment in
                        equipment.getItemVIew()
                            .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                    }
                }
            }
        }
    }
}
