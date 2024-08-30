//
//  SVGView.swift
//  SportScore
//
//  Created by pc on 31/07/2024.
//

import SwiftUI
import SVGKit
import UIKit

enum Axis {
    case Vertical
    case Horizoltal
}

enum ImagePosition {
    case Left
    case Right
    case Top
    case Bottom
}

class SVGLoader {
    static func loadSVG(from url: URL, completion: @escaping (SVGKImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load SVG: \(String(describing: error))")
                completion(nil)
                return
            }
            let svgImage = SVGKImage(data: data)
            DispatchQueue.main.async {
                completion(svgImage)
            }
        }.resume()
    }
}

struct SVGKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> SVGKFastImageView {
        let svgView = SVGKFastImageView(frame: .zero)
        svgView.contentMode = .scaleAspectFit
        return svgView
    }

    func updateUIView(_ uiView: SVGKFastImageView, context: Context) {
        SVGLoader.loadSVG(from: url) { svgImage in
            uiView.image = svgImage
        }
    }
}
