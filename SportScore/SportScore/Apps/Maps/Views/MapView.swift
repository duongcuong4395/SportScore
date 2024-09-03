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
    
    @EnvironmentObject var countryVM: CountryViewModel
    @EnvironmentObject var appVM: AppViewModel
    @EnvironmentObject var leaguesVM: LeaguesViewModel
    @EnvironmentObject var sportTypeVM: SportTypeViewModel
    
    
    
    
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
                                        withAnimation(.spring()) {
                                            mapVM.moveTo(coordinate: ct.model.coordinate, zoom: 1.0)
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                markerVM.toggleShowDetail(of: ct.model)
                                                print("=== marker touch:", ct.model)
                                                
                                                
                                                UIApplication.shared.endEditing()
                                                
                                                appVM.resetTextSearch()
                                                countryVM.resetFilter()
                                                countryVM.setDetail(by: ct.model as! CountryModel)
                                                
                                                leaguesVM.resetModels()
                                                leaguesVM.fetch(from: ct.model as! CountryModel, by: sportTypeVM.selected.rawValue) {
                                                }
                                                
                                                appVM.showMap.toggle()
                                            }
                                            
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
                    //MapUserLocationButton()
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
