//
//  QuickWeatherApp.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/05.
//

import SwiftUI

@main
struct QuickWeatherApp: App {
    @StateObject var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            FirstView()
                .environmentObject(locationManager)
        }
    }
}
