//
//  QuickWeatherApp.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/05.
//

import SwiftUI

@main
struct QuickWeatherApp: App {
    @StateObject var localDataManager = LocationDataManager()
    
    var body: some Scene {
        WindowGroup {
//            FirstView()
//                .environmentObject(localDataManager)
            LocationView()
                .environmentObject(localDataManager)
        }
    }
}
