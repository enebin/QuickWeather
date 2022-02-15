//
//  QuickWeatherApp.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/05.
//

import SwiftUI
import Firebase

// TODO: 누르는 횟수 제한 + 스토어 연동하기
// TODO: 방명록 페이징 + 개수 세기
// TODO: 방명록 안내문 추가
// TODO:


@main
struct QuickWeatherApp: App {
    @StateObject var localDataManager = LocationDataManager()
    
    init() {
        FirebaseApp.configure()
    }

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
