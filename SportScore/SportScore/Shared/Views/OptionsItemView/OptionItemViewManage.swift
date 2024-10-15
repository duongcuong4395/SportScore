//
//  OptionItemViewManage.swift
//  SportScore
//
//  Created by pc on 15/08/2024.
//

import Foundation
import SwiftUI

// MARK: - Item Options Delegate
protocol ItemDelegate {
    func toggleLike<T: Decodable>(for model: T)
    func toggleFavorite<T: Decodable>(for model: T)
    func toggleNotify<T: Decodable>(for model: T)
    
    func openPlayVideo<T: Decodable>(for model: T)
    
    
    
    func viewDetail<T: Decodable>(for model: T)
    func pushFireBase<T: Decodable>(for model: T)
    func selected<T: Decodable>(for model: T)
    
    // func viewOnMap<T: Decodable>(for model: T)
    // func getRoute<T: Decodable>(for model: T)
    // func viewRoute<T: Decodable>(for model: T)
    // func drawOnMap<T: Decodable>(for model: T)
}

extension ItemDelegate {
    func viewOnMap<T: Decodable>(for model: T) {
        return
    }
    
    func toggleLike<T: Decodable>(for model: T) {
        return
    }
    
    func toggleFavorite<T: Decodable>(for model: T) {
        return
    }
    
    func toggleNotify<T: Decodable>(for model: T) {
        return
    }
    
    func openPlayVideo<T: Decodable>(for model: T) {
        return
    }
    
    func viewRoute<T: Decodable>(for model: T) {
        return
    }
    
    func viewDetail<T: Decodable>(for model: T) {
        return
    }
    
    
    func pushFireBase<T: Decodable>(for model: T) {
        return
    }
    
    func drawOnMap<T: Decodable>(for model: T) {
        return
    }
    
    func selected<T: Decodable>(for model: T) {
        return
    }
    
    func getRoute<T: Decodable>(for model: T) {
        return
    }
}

// MARK: - Item Options View
enum IconDetailType: String {
    case Default = "ellipsis.circle"
    case Down = "chevron.down"
    case Up = "chevron.up"
    case Right = "chevron.right"
    case Route3D = "move.3d"
    case Route = "point.topleft.down.curvedto.point.filled.bottomright.up"
    case RouteBranch = "arrow.triangle.branch"
    case RouteSwap = "arrow.triangle.swap"
    case Star = "wand.and.stars"
    case MultiStar = "sparkles"
    
    
}

protocol ItemOptionsBuilder: Decodable{
    //func getLiked() -> Bool
    func getFavorite() -> Bool
    func getNotify() -> Bool
}

extension ItemOptionsBuilder {
    
    /*
    @ViewBuilder
    func getBtnLike(with event: ItemDelegate) -> some View {
        buildItemButton(with: getLiked() ? "heart.fill" : "heart") {
            event.toggleLike(for: self)
        }
    }
    */
    
    @ViewBuilder
    func getBtnFavorie(with event: ItemDelegate) -> some View {
        buildItemButton(with: getFavorite() ? "heart.fill" : "heart") {
            event.toggleFavorite(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnOpenVideo(with event: ItemDelegate) -> some View {
        buildItemButton(with: "play.rectangle") {
            event.openPlayVideo(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnNotify(with event: ItemDelegate) -> some View {
        buildItemButton(with: getNotify() ? "bell.fill" : "bell") {
            event.toggleNotify(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnViewDetail(with event: ItemDelegate, type: IconDetailType = .Default) -> some View {
        buildItemButton(with: type.rawValue) {
            event.viewDetail(for: self)
        }
    }
    
    /*
    @ViewBuilder
    func getBtnViewMap(on mapVM: MapsViewModel) -> some View {
        buildItemButton(with: "mappin.and.ellipse") {
            guard let model = self as? MarKerData else { return }
            Task{ @MainActor in
                mapVM.viewOnMap(for: model)
                //mapVM.setMarkerSelected(from: model)
            }
        }
    }
    */
    
    @ViewBuilder
    private func buildItemButton(with imageName: String,  action: @escaping () -> Void) -> some View {
        Image(systemName: imageName)
            .onTapGesture {
                action()
            }
    }
    
    @ViewBuilder
    func getBtnPushFireBase(with event: ItemDelegate) -> some View {
        buildItemButton(with: "cloud") {
            event.pushFireBase(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnDrawOnMap(with event: ItemDelegate) -> some View {
        buildItemButton(with: "gearshape.2") {
            event.drawOnMap(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnSelected(with event: ItemDelegate) -> some View {
        buildItemButton(with: "hand.tap.fill") {
            event.selected(for: self)
        }
    }
    
    @ViewBuilder
    func getBtnRoute(with event: ItemDelegate, type: IconDetailType = .Default) -> some View {
        buildItemButton(with: type.rawValue) {
            event.getRoute(for: self)
        }
    }
}
