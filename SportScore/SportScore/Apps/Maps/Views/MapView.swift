//
//  MapView.swift
//  SinEnvironment
//
//  Created by pc on 23/06/2024.
//

import Foundation
import SwiftUI
import MapKit


struct MapView:View {
    
    @State private var region = MKCoordinateRegion(
           center: CLLocationCoordinate2D(latitude: 1.305984, longitude: 103.828292),
           span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
       )
    @EnvironmentObject var mapVM: MapViewModel
    @EnvironmentObject var markerVM: MarkerViewModel
    
    @EnvironmentObject var polylineVM: PolylineViewModel
    
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                
                Map(position: $mapVM.position) {
                    ForEach(markerVM.markers, id: \.id) { ct in
                        Annotation(ct.model.title, coordinate: ct.getLocation()) {
                            ZStack {
                                ct.model.getIconView()
                                    .onTapGesture {
                                        withAnimation {
                                            markerVM.toggleShowDetail(of: ct.model)
                                        }
                                        
                                    }
                                
                                ct.model.getDetailView()
                                    .opacity(ct.showDetail ? 1: 0)
                                    .zIndex(1)
                                    .onTapGesture{
                                        print("onTapGesture:", ct.model)
                                    }
                            }
                        }
                        .annotationTitles(.hidden)
                    }
                    
                    ForEach(polylineVM.polylines, id: \.name) { poly in
                        MapPolyline(coordinates: poly.coordinates)
                            .stroke(CustomShapeStyle(), lineWidth: 2.0)
                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
                .mapStyle(.hybrid)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onMapCameraChange { context in
                    print("context.region", context.region)
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
            }
                
            /*
            Map(coordinateRegion: $mapVM.region
                , annotationItems: markerVM.markers) { ct in
                
                MapAnnotation(coordinate: ct.getLocation()) {
                    ZStack {
                        ct.model.getIconView()
                            .onTapGesture {
                                withAnimation {
                                    markerVM.toggleShowDetail(of: ct.model)
                                }
                                
                            }
                        
                        ct.model.getDetailView()
                            .opacity(ct.showDetail ? 1: 0)
                            .zIndex(1)
                            .onTapGesture{
                                print("onTapGesture:", ct.model)
                            }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            */
            /*
            MapKitView()
                .onAppear {
                    setupMarkersAndPolylines()
                }
             */
        }
    }
}


struct CustomShapeStyle: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle {
        if environment.colorScheme == .light {
            return Color.blue.blendMode(.lighten)
        } else {
            return Color.blue.blendMode(.darken)
        }
    }
}
