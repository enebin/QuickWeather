//
//  FIrstView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/06.
//

import SwiftUI
import Combine

struct FirstView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            if let coord = locationManager.coord {
                LocalWeatherView(viewModel: LocalWeatherViewModel(coord: coord))
                    .environmentObject(locationManager)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {locationManager.setCurrentLocation()}) {
                                Image(systemName: "scope")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {locationManager.setRandomLocation()}) {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                    })
                    .accentColor(.white)
            }
        }
        
        
//        TabView {
//            WeatherListView()
//            if let city = locationManager.locationName {
//                LocalWeatherView(viewModel: LocalWeatherViewModel(name: city))
//            }
//        }
    }
}

struct FIrstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
