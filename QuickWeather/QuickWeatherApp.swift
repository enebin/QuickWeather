//
//  QuickWeatherApp.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/05.
//

import SwiftUI
import Firebase

@main
struct QuickWeatherApp: App {
    @StateObject var localDataManager = LocationDataManager()
    init() { FirebaseApp.configure() }

    var body: some Scene {
        WindowGroup {
//            FirstView()
//                .environmentObject(localDataManager)
            LocationView()
                .environmentObject(localDataManager)
        }
    }
}
