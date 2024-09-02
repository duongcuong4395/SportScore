//
//  MarkerViewModel.swift
//  SinEnvironment
//
//  Created by pc on 23/06/2024.
//

import Foundation
import MapKit
import SwiftUI
import UIKit

protocol MarkerData {
    var coordinate: CLLocationCoordinate2D { get }
    var title: String { get }

    func getIconView() -> AnyView
    func getDetailView()  -> AnyView
    
    func getMarkerType() -> MarkerType
    
    func getMarkerModel() -> MarkerModel
    
    
    func getPoint() -> CGPoint
}

extension MarkerData {
    @MainActor
    func renderIcon() -> UIImage? {
        let renderer = ImageRenderer(content: getIconView())
        
        if let uiImage = renderer.uiImage {
            return uiImage//.withRenderingMode(.alwaysOriginal)
        }
        
        return nil
    }
    
    func getBoundMarker() -> CGRect {
        CGRect(x: 0, y: 0, width: 70, height: 50)
    }
    
    func getPoint() -> CGPoint {
        CGPoint(x: 0, y: 0)
    }
    
    func getIcon() -> UIView {
        let hostingController = UIHostingController(rootView: getIconView())
        hostingController.view.bounds = getBoundMarker()
        hostingController.view.layer.cornerRadius = 8.0
        //hostingController.view.layer.masksToBounds = true
        hostingController.view.layer.position = getPoint()
        //hostingController.view.backgroundColor = .clear
        return hostingController.view
    }
}



// MARK: - LabelLocation
struct Location: Codable {
    var latitude, longitude: Double
}

enum MarkerType: String {
    case Country
    case Weather
    case Humidity
    case WindDirection
    case AirTemperature
    case Rainfall
    case AirQualityPM25
    case WindSpeed
}

struct MarkerModel: Identifiable {
    var id = UUID()
    var showDetail: Bool = false
    var model: MarkerData
}

extension MarkerModel {
    func getLocation() -> CLLocationCoordinate2D {
        model.coordinate
    }
}

class MarkerViewModel: ObservableObject{
    @Published var markers: [MarkerModel] = []
    @Published var markerSelected: MarkerModel?
    
    func addMarker(from data: MarkerData) {
        let mk = markers.first { $0.model.title == data.title && $0.model.getMarkerType() == data.getMarkerType() }
        guard mk == nil else { return }
        
        DispatchQueue.main.async {
            let marker = MarkerModel(model: data)
            self.markers.append(marker)
        }
    }
    
    func addListMarker(from datas: [MarkerData]) {
        markers = datas.map { $0.getMarkerModel() }
    }
    
    
    func toggleShowDetail(of data: MarkerData) {
        self.clearAllInfoMarker()
        let ind = markers.firstIndex { $0.model.title == data.title && $0.model.getMarkerType() == data.getMarkerType() }
        guard let ind = ind else { return }
        DispatchQueue.main.async {
            //self.markers[ind].showDetail.toggle()
        }
    }
    
    func clearAllInfoMarker() {
        let ind = markers.firstIndex { $0.showDetail == true }
        guard let ind = ind else { return }
        DispatchQueue.main.async {
            self.markers[ind].showDetail = false
        }
    }
    
    
}


// MARK: For clear
extension MarkerViewModel {
    func clearAll() {
        markers = []
    }
    
    func clear(by type: MarkerType) {
        markers.removeAll{ mk in
            mk.model.getMarkerType() == type
        }
    }
}



// MARK: - For New Maps

class PolylineViewModel: ObservableObject {
    @Published var polylines: [Polyline] = []
    
    
    func addPolyline(with item: Polyline) {
        guard polylines.first(where: { $0.name == item.name }) != nil else { 
            polylines.append(item)
            return }
        
    }
}


struct MapKitView: UIViewRepresentable {
    @EnvironmentObject var markerVM: MarkerViewModel
    @EnvironmentObject var polylineVM: PolylineViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapKitView

        init(_ parent: MapKitView) {
            self.parent = parent
        }

        // MARK: - Marker Handling

        @MainActor
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let markerAnnotation = annotation as? MarkerAnnotation else { return nil }
            return createMarkerView(for: markerAnnotation, on: mapView)
        }

        @MainActor
        func createMarkerView(for annotation: MarkerAnnotation, on mapView: MKMapView) -> MKAnnotationView {
            let identifier = annotation.markerModel.model.getMarkerType().rawValue
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }

            // Customize annotation view based on MarkerData
            //if let markerData = annotation.markerModel.model as? MarkerData {
                //annotationView?.glyphImage = UIImage(systemName: "mappin.circle")
                //annotationView?.detailCalloutAccessoryView = markerData.getDetailView().toUIView()
                //let iconView = markerData.getIconView().toUIView()
                //annotationView?.leftCalloutAccessoryView = iconView
                //annotationView?.image = annotation.markerModel.model.renderIcon()
            //}

            //annotationView?.glyphImage = annotation.markerModel.model.renderIcon()
            
            //annotationView?.markerTintColor = .clear
            
            if let originalImage = annotation.markerModel.model.renderIcon() {
                let renderedImage = originalImage.withRenderingMode(.alwaysOriginal)
                annotationView?.glyphImage = renderedImage
                annotationView?.markerTintColor = UIColor.clear
                annotationView?.glyphTintColor = UIColor.clear
                annotationView?.glyphTintColor = nil
            }
            return annotationView!
        }

        func addMarkers(to mapView: MKMapView, from markers: [MarkerModel]) {
            let markerAnnotations = markers.map { MarkerAnnotation(markerModel: $0) }
            mapView.addAnnotations(markerAnnotations)
        }

        func removeMarkers(from mapView: MKMapView) {
            mapView.removeAnnotations(mapView.annotations)
        }

        // MARK: - Polyline Handling

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                return createPolylineRenderer(for: polyline)
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        func createPolylineRenderer(for polyline: MKPolyline) -> MKPolylineRenderer {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }

        func addPolylines(to mapView: MKMapView, from polylines: [Polyline]) {
            let polylineOverlays = polylines.map { polyline -> MKPolyline in
                let coords = polyline.coordinates
                return MKPolyline(coordinates: coords, count: coords.count)
            }
            mapView.addOverlays(polylineOverlays)
        }

        func removePolylines(from mapView: MKMapView) {
            mapView.removeOverlays(mapView.overlays)
        }

        // MARK: - Touch Event Handling

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let markerAnnotation = view.annotation as? MarkerAnnotation {
                handleMarkerSelection(markerAnnotation)
            }
        }

        func handleMarkerSelection(_ markerAnnotation: MarkerAnnotation) {
            parent.markerVM.toggleShowDetail(of: markerAnnotation.markerModel.model)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update markers
        context.coordinator.removeMarkers(from: uiView)
        context.coordinator.addMarkers(to: uiView, from: markerVM.markers)

        // Update polylines
        context.coordinator.removePolylines(from: uiView)
        context.coordinator.addPolylines(to: uiView, from: polylineVM.polylines)
    }
}

// MARK: - Marker Annotation

class MarkerAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let markerModel: MarkerModel

    init(markerModel: MarkerModel) {
        self.markerModel = markerModel
        self.coordinate = markerModel.model.coordinate
        self.title = markerModel.model.title
        self.subtitle = nil // Bạn có thể đặt subtitle nếu cần
    }
}

// MARK: - UIView Extension for SwiftUI Views

extension AnyView {
    func toUIView() -> UIView {
        let controller = UIHostingController(rootView: self)
        return controller.view
    }
}

// Polyline Model
struct Polyline {
    var id: Int
    var name: String
    var coordinates: [CLLocationCoordinate2D]
}
