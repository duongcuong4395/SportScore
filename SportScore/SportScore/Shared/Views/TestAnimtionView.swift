//
//  TestAnimtionView.swift
//  SportScore
//
//  Created by pc on 01/08/2024.
//

import SwiftUI


// MARK: - Module
enum AnimationDirection {
    case leftToRight, rightToLeft, topToBottom, bottomToTop
}

struct SequentialAnimationModifier: ViewModifier {
    var delay: Double
    var direction: AnimationDirection
    @Binding var isVisible: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: xOffset, y: yOffset)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .delay(delay), value: UUID()
            )
    }
    
    private var xOffset: CGFloat {
        switch direction {
        case .leftToRight:
            return isVisible ? 0 : -UIScreen.main.bounds.width
        case .rightToLeft:
            return isVisible ? 0 : UIScreen.main.bounds.width
        case .topToBottom, .bottomToTop:
            return 0
        }
    }
    
    private var yOffset: CGFloat {
        switch direction {
        case .topToBottom:
            return isVisible ? 0 : -UIScreen.main.bounds.height
        case .bottomToTop:
            return isVisible ? 0 : UIScreen.main.bounds.height
        case .leftToRight, .rightToLeft:
            return 0
        }
    }
}

extension View {
    func sequentiallyAnimating(isVisible: Binding<Bool>, delay: Double, direction: AnimationDirection) -> some View {
        self.modifier(SequentialAnimationModifier(delay: delay, direction: direction, isVisible: isVisible))
    }
}



// MARK: - Test

struct Car: Identifiable {
    var id = UUID()
    var name: String
    var image: String
}

struct TestAnimationView: View {
    @State private var cars: [Car] = [
        Car(name: "Car 1", image: "car_image_1"),
        Car(name: "Car 2", image: "car_image_2"),
        Car(name: "Car 3", image: "car_image_3")
    ]
    
    @State private var showCars = [Bool](repeating: false, count: 3)
    
    var body: some View {
        VStack {
            
            
            HStack {
                ForEach(Array(cars.enumerated()), id: \.element.id) { index, car in
                    VStack {
                        Image(car.image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        Text(car.name)
                            .font(.title)
                    }
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .sequentiallyAnimating(isVisible: $showCars[index], delay: Double(index) * 0.3, direction: .topToBottom)
                    //.offset(x: showCars[index] ? 0 : -UIScreen.main.bounds.width)
                }
            }
            .padding(5)
            .onAppear{
                for index in cars.indices {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showCars[index] = true
                        }
                    }
                }
            }
        }
    }
}





import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    
    @Published var x = 0.0
    @Published var y = 0.0
    
    
    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
            guard let motion = data?.attitude else { return }
            self?.x = motion.roll
            self?.y = motion.pitch
        }
    }
}
