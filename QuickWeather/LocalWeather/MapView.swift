//
//  MapView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/08.
//

import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}


class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    @Published var markers: [Marker] = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), tint: .red))]
}

struct MapView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        Map(coordinateRegion: $viewModel.region, interactionModes: [.zoom], annotationItems: viewModel.markers) {
            marker in
            marker.location
        }
        
    }
    

    init(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: location,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        
        viewModel = MapViewModel()
        viewModel.region = region
        viewModel.markers = [Marker(location: MapMarker(coordinate: location, tint: .red))]
        print("Region: \(viewModel.region)")
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914))
//    }
//}
