//
//  TimeManager.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/15.
//

import SwiftUI

class TimeManager: ObservableObject {
    @Published var isActive = true
    
    func waitUntilNextChance() {
        isActive = false
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.isActive = true
        }
    }
}
