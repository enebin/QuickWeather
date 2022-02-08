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
        if let name = locationManager.locationName {
            LocalWeatherView(viewModel: LocalWeatherViewModel(name: name))
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
