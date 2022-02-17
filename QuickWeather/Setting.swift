//
//  Setting.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/17.
//

import SwiftUI
import Combine

class Setting: ObservableObject {
    enum TemperatureType: String {
        case celcius = "Celcius"
        case ferenheit = "Ferenheit"
    }
    
    @Published var tempType: TemperatureType
    private var subsriptions = Set<AnyCancellable>()
    
    init() {
        if let defaultTempUnit = UserDefaults.standard.object(forKey: "tempUnit") {
            print(defaultTempUnit)
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
        
        $tempType
            .sink { tempType in
                UserDefaults.standard.set(tempType.rawValue, forKey: "tempUnit")
            }
            .store(in: &subsriptions)
    }
}
