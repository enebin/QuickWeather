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
    @Published var isFirstToday: Bool
    @Published var remainingChances: Int
    
    private func loadTemperatureUnit() {
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
    
    // TODO: Let's use bool
    private func loadRemainingChances() {
        let userDefaultKey = "remainingChances"
        let defaultChances = 30
        
        if let remainingChancesToday = UserDefaults.standard.object(forKey: userDefaultKey) {
            self.remainingChances = remainingChancesToday as! Int
        } else {
            UserDefaults.standard.set(defaultChances, forKey: userDefaultKey)
            self.remainingChances = defaultChances
        }
    }
    
    func checkFirstToday() {
        let userDefaultKey = "savedDate"
        let currentDate = Calendar.current.component(.day, from: Date())
        
        if let savedDate = UserDefaults.standard.object(forKey: userDefaultKey) {
            print(currentDate, savedDate)
            if savedDate as! Int == currentDate {
                self.isFirstToday = false
            } else {
                // Set isFirsToday true and chances full
                UserDefaults.standard.set(currentDate, forKey: userDefaultKey)
                setRemainingChancesFull()
                self.isFirstToday = true
            }
        } else {
            UserDefaults.standard.set(currentDate, forKey: userDefaultKey)
            self.isFirstToday = true
        }
    }
    
    private func setRemainingChancesFull() {
        let userDefaultKey = "remainingChances"
        remainingChances = 30
        
        UserDefaults.standard.set(remainingChances, forKey: userDefaultKey)
    }
    
    func setIsFirstExecutionFalse() {
        let userDefaultKey = "isFirstExcution"
        
        UserDefaults.standard.set(false, forKey: userDefaultKey)
        self.isFirstExcution = false
    }
    
    func setRemainingChancesDecreased() {
        let userDefaultKey = "remainingChances"
        remainingChances -= 1
        
        UserDefaults.standard.set(remainingChances, forKey: userDefaultKey)
    }
    
    init() {
        self.tempType = .celcius
        self.remainingChances = 0
        self.isFirstExcution = true
        self.isFirstToday = false
        
        loadTemperatureUnit()
        loadRemainingChances()
        checkFirstExcution()
        checkFirstToday()
        
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
