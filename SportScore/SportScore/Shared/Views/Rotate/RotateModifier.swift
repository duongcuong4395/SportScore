//
//  RotateModifier.swift
//  SportScore
//
//  Created by pc on 22/08/2024.
//

import Foundation
import SwiftUI

enum RotationAxis {
    case x, y
}


struct RotateOnAppearModifier: ViewModifier {
    @State private var isRotated = false
    
    let angle: Double
    let duration: Double
    let axis: RotationAxis
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(isRotated ? 0 : angle),
                axis: axis == .x ? (x: 1.0, y: 0.0, z: 0.0) : (x: 0.0, y: 1.0, z: 0.0)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: duration)) {
                    isRotated = true
                }
            }
    }
}


extension View {
    func rotateOnAppear(angle: Double = -90, duration: Double = 0.5, axis: RotationAxis = .x) -> some View {
        self.modifier(RotateOnAppearModifier(angle: angle, duration: duration, axis: axis))
    }
}
