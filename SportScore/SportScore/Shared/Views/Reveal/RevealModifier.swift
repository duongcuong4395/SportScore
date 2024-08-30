//
//  RevealModifier.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import Foundation
import SwiftUI

enum RevealDirection {
    case bottomToTop, topToBottom, leftToRight, rightToLeft
}

struct RevealEffectModifier: ViewModifier {
    @State private var revealPercentage: CGFloat = 0.0
    let duration: Double
    let direction: RevealDirection

    func body(content: Content) -> some View {
        content
            .mask(
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.black, .black.opacity(0)]),
                        startPoint: startPoint,
                        endPoint: endPoint
                    ))
                    .frame(width: maskWidth, height: maskHeight)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    revealPercentage = 1.0
                }
            }
    }

    private var startPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .bottom
        case .topToBottom: return .top
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        }
    }

    private var endPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .top
        case .topToBottom: return .bottom
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        }
    }

    private var maskWidth: CGFloat? {
        return direction == .leftToRight || direction == .rightToLeft ? nil : 200
    }

    private var maskHeight: CGFloat? {
        return direction == .topToBottom || direction == .bottomToTop ? nil : 200
    }
}


extension View {
    func revealEffect(duration: Double = 1.0, direction: RevealDirection = .bottomToTop) -> some View {
        self.modifier(RevealEffectModifier(duration: duration, direction: direction))
    }
}


// MARK: - For Fade IN

enum FadeDirection {
    case bottomToTop, topToBottom, leftToRight, rightToLeft
}

struct FadeInEffectModifier: ViewModifier {
    @State private var revealPercentage: CGFloat = 0.0
    let duration: Double
    let direction: FadeDirection
    let isLoop: Bool

    func body(content: Content) -> some View {
        content
            .overlay(overlayView.mask(content))
            .onAppear {
                startAnimation()
            }
    }

    private func startAnimation() {
        withAnimation(.easeInOut(duration: duration)) {
            revealPercentage = 1.0
        }

        if isLoop {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                resetAnimation()
            }
        }
    }

    private func resetAnimation() {
        revealPercentage = 0.0
        startAnimation()
    }

    private var overlayView: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: revealPercentage),
                .init(color: .black, location: revealPercentage)
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    private var startPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .bottom
        case .topToBottom: return .top
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        }
    }

    private var endPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .top
        case .topToBottom: return .bottom
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        }
    }
}

extension View {
    func fadeInEffect(duration: Double = 1.0, direction: FadeDirection = .bottomToTop, isLoop: Bool = false) -> some View {
        self.modifier(FadeInEffectModifier(duration: duration, direction: direction, isLoop: isLoop))
    }
}
