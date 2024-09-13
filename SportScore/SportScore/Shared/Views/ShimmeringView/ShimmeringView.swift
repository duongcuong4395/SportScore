//
//  ShimmeringView.swift
//  SportScore
//
//  Created by pc on 24/08/2024.
//

import Foundation
import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                shimmerOverlay()
                    .mask(content)
                    .offset(x: phase * 350)
            )
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
    
    private func shimmerOverlay() -> LinearGradient {
        let gradient = Gradient(stops: [
            .init(color: Color.white.opacity(0.4), location: 0.3),
            .init(color: Color.white.opacity(0.8), location: 0.5),
            .init(color: Color.white.opacity(0.4), location: 0.7)
        ])
        
        return LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing)
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}
