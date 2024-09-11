//
//  OnboardingListSportView.swift
//  SportScore
//
//  Created by pc on 05/09/2024.
//

import SwiftUI
import Kingfisher
import SwiftfulLoadingIndicators

struct OnboardingListSportView: View {
    var columns: [GridItem] = [GridItem(), GridItem(), GridItem()]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, content: {
                ForEach(SportType.allCases, id: \.self) { sport in
                    
                    if sport != .Darts {
                        VStack {
                            KFImage(URL(string: sport.getImageUrl(with: false)
                                       ))
                                .placeholder { progress in
                                    LoadingIndicator(animation: .circleBars, size: .medium, speed: .normal)
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30, height: 30)
                                
                            Text(sport.rawValue)
                                .font(.caption)
                        }
                        .padding(.horizontal, 5)
                        .rotateOnAppear(angle: -90, duration: 0.5, axis: .x)
                    }
                }
            })
        }
    }
}
