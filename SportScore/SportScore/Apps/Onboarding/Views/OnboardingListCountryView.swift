//
//  OnboardingListCountryView.swift
//  SportScore
//
//  Created by pc on 05/09/2024.
//

import SwiftUI

struct OnboardingListCountryView: View {
    @EnvironmentObject var countryVM: CountryViewModel
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: countryVM.columns) {
                    ForEach(countryVM.models, id: \.id) { country in
                        country.getItemView(with: {
                            EmptyView()
                        })
                        .padding(0)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .y)
                    }
                }
            }
        }
    }
}
