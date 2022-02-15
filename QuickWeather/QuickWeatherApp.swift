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
            LocationView()
                .environmentObject(localDataManager)
//                .onAppear {
//                    for family in UIFont.familyNames {
//                        print("\(family)")
//
//                        for name in UIFont.fontNames(forFamilyName: family) {
//                            print("\(name)")
//                        }
//                    }
//                }
        }
    }
}
