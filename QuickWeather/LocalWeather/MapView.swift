//
//  MapView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/08.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.zoom])
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
