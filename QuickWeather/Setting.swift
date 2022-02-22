//
//  Setting.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/17.
//

import SwiftUI
import Combine
import StoreKit

class Setting: ObservableObject {
    private var subsriptions = Set<AnyCancellable>()
    private let defaultChances = 30
    private let keyContainer = KeyContainer()
    
    @Published var tempType: TemperatureType
    @Published var isFirstExecution: Bool
    @Published var isFirstToday: Bool
    @Published var remainingChances: Int
    
    private func showReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    /// Load the setting of temperature unit
    private func loadTemperatureUnit() {
        let userDefaultKey = keyContainer.tempUnitKey
        if let defaultTempUnit = UserDefaults.standard.object(forKey: userDefaultKey) {
            if let tempType = TemperatureType(rawValue: defaultTempUnit as! String) {
                self.tempType = tempType
            } else {
                print("Error occurs while get temp unit")
                fatalError()
            }
        } else {
            UserDefaults.standard.set("Celcius", forKey: userDefaultKey)
            self.tempType = TemperatureType(rawValue: "Celcius")!
        }
    }
    
    /// Check if the user have ever opened the app after installed
    private func checkFirstExcution() {
        let userDefaultIsFirst = UserDefaults.standard.object(forKey: keyContainer.firstExecutionKey)
        
        if userDefaultIsFirst == nil {
            UserDefaults.standard.set(true, forKey: keyContainer.firstExecutionKey)
            UserDefaults.standard.set(false, forKey: keyContainer.reviewRequestKey)
            UserDefaults.standard.set(Date(), forKey: keyContainer.firstExecutionTimeKey)
        } else {
            self.isFirstExecution = userDefaultIsFirst as! Bool
        }
    }
    
    /// Load remaining chances from the storage(UserDefault)
    private func loadRemainingChances() {
        let userDefaultKey = keyContainer.remainingChancesKey
        let defaultChances = self.defaultChances  // MARK: Chances can be adjusted
        
        if let remainingChancesToday = UserDefaults.standard.object(forKey: userDefaultKey) {
            self.remainingChances = remainingChancesToday as! Int
        } else {
            UserDefaults.standard.set(defaultChances, forKey: userDefaultKey)
            self.remainingChances = defaultChances
        }
    }
    
    /// Check if user opens the app first time
    func checkFirstToday() {
        let currentDate = Calendar.current.component(.day, from: Date())
        
        if let savedDate = UserDefaults.standard.object(forKey: keyContainer.savedDateKey) {
            if savedDate as! Int == currentDate {
                // A day has not passed
                self.isFirstToday = false

                // Check if a day elapsed after user executed app first time
                if let time = UserDefaults.standard.object(forKey: keyContainer.firstExecutionTimeKey),
                   let isRequested = UserDefaults.standard.object(forKey: keyContainer.reviewRequestKey),
                   isRequested as! Bool == false
                {
                    let current = Date()
                    print("###\(time) \(isRequested) \(current - (time as! Date))")
                    if current - (time as! Date) > 60 * 60 * 24 { // 60초 60분 24시간
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self.showReview()
                        }
                        UserDefaults.standard.set(true, forKey: keyContainer.reviewRequestKey)
                    }
                }
                
            } else {
                // A day passed
                // Set new UserDefault value: Today's date, for later use
                UserDefaults.standard.set(currentDate, forKey: keyContainer.savedDateKey)
                
                // Set remainingChances Full
                setRemainingChancesFull()
                self.isFirstToday = true
            }
        } else {
            UserDefaults.standard.set(currentDate, forKey: keyContainer.savedDateKey)
            self.isFirstToday = true
        }
    }
    
    /// Make remaining chacnes default state
    func setRemainingChancesFull() {
        let userDefaultKey = keyContainer.remainingChancesKey
        remainingChances = self.defaultChances   // MARK: Chances can be adjusted
        
        UserDefaults.standard.set(remainingChances, forKey: userDefaultKey)
    }
    
    func setRemainingChancesDecreased() {
        let userDefaultKey = keyContainer.remainingChancesKey
        remainingChances -= 1
        
        UserDefaults.standard.set(remainingChances, forKey: userDefaultKey)
    }
    
    func setIsFirstExecutionFalse() {
        let userDefaultKey = keyContainer.firstExecutionKey
        
        UserDefaults.standard.set(false, forKey: userDefaultKey)
        self.isFirstExecution = false
    }
    
    
    init() {
        self.tempType = .celcius
        self.remainingChances = 0
        self.isFirstExecution = true
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
    
    private struct KeyContainer {
        let tempUnitKey = "tempUnit"
        let firstExecutionKey = "isFirstExcution"
        let firstExecutionTimeKey = "firstExecutionTime"
        let reviewRequestKey = "isReviewRequested"
        let remainingChancesKey = "remainingChances"
        let savedDateKey = "savedDate"
    }
}
