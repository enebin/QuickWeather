//
//  MapView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/08.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion

    var body: some View {
        Map(coordinateRegion: $region, interactionModes: [.zoom])
    }
    
    init(_ coord: CLLocationCoordinate2D) {
        self.region = MKCoordinateRegion(
            center: coord,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
        print(region)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914))
    }
}
