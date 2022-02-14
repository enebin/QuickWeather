//
//  FIrstView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/06.
//

import SwiftUI
import Combine

struct FirstView: View {
    @EnvironmentObject var locationDataManager: LocationDataManager
    @StateObject var timeManager = TimeManager()
    
    var body: some View {
        NavigationView {
//            LocalWeatherView()
//                .environmentObject(locationDataManager)
//                .navigationTitle("")
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar(content: {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//                            locationDataManager.setCurrentLocation()
//                        }) {
//                            Image(systemName: "scope")
//                        }
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            locationDataManager.setRandomLocation()
//                            timeManager.waitUntilNextChance()
//                        }) {
//                            Image(systemName: "arrow.clockwise")
//                        }
//                        .disabled(!timeManager.isActive)
//                    }
//                })
//                .accentColor(.white)
        }
    }
}

class TimeManager: ObservableObject {
    @Published var isActive = true
    private var subscriptions = Set<AnyCancellable>()
    
    func waitUntilNextChance() {
        isActive = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.isActive = true
        }
    }
}

struct FIrstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
