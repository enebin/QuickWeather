//
//  Setting.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/17.
//

import SwiftUI
import Combine

class Setting: ObservableObject {
    private var subsriptions = Set<AnyCancellable>()
    
    @Published var tempType: TemperatureType
    @Published var chanceLeft: Int
    
    private func loadTempType() {
        if let defaultTempUnit = UserDefaults.standard.object(forKey: "tempUnit") {
            if let tempType = TemperatureType(rawValue: defaultTempUnit as! String) {
                self.tempType = tempType
            } else {
                print("Error occurs while get temp unit")
                fatalError()
            }
        } else {
            UserDefaults.standard.set("Celcius", forKey: "tempUnit")
            self.tempType = TemperatureType(rawValue: "Celcius")!
        }
    }
    
    //TODO: Improve here
    private func loadChanceLeft() {
        if let chanceLeftToday = UserDefaults.standard.object(forKey: "chanceLeft") {
            self.chanceLeft = chanceLeftToday as! Int
        } else {
            UserDefaults.standard.set("10", forKey: "chanceLeft")
            self.chanceLeft = 10
        }
    }
    
    init() {
        self.tempType = .celcius
        self.chanceLeft = 0
        
        loadTempType()
//        loadChanceLeft()
        
        $tempType
            .sink { tempType in
                UserDefaults.standard.set(tempType.rawValue, forKey: "tempUnit")
            }
            .store(in: &subsriptions)
    }
}

extension Setting {
    enum TemperatureType: String {
        case celcius = "Celcius"
        case ferenheit = "Ferenheit"
    }
}
