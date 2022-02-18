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
    @Published var isFirstExcution: Bool
    @Published var remainingChances: Int
    
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
    
    private func checkFirstExcution() {
        let userDefaultKey = "isFirstExcution"
        let userDefaultIsFirst = UserDefaults.standard.object(forKey: userDefaultKey)
        
        if userDefaultIsFirst == nil {
            UserDefaults.standard.set(true, forKey: userDefaultKey)
        } else {
            self.isFirstExcution = userDefaultIsFirst as! Bool
        }
    }
    
    //TODO: Improve here
    private func loadChanceLeft() {
        let userDefaultKey = "remainingChances"
        if let remainingChancesToday = UserDefaults.standard.object(forKey: userDefaultKey) {
            self.remainingChances = remainingChancesToday as! Int
        } else {
            UserDefaults.standard.set("10", forKey: userDefaultKey)
            self.remainingChances = 30
        }
    }
    
    func setIsFirstExecutionFalse() {
        let userDefaultKey = "isFirstExcution"
        UserDefaults.standard.set(false, forKey: userDefaultKey)
        self.isFirstExcution = false
    }
    
    init() {
        self.tempType = .celcius
        self.remainingChances = 0
        self.isFirstExcution = true
        
        loadTempType()
        loadChanceLeft()
        checkFirstExcution()
        
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
