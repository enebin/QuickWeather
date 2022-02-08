//
//  LocalWeatherViewModel.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import SwiftUI
import Combine

class LocalWeatherViewModel: ObservableObject {
    @Published var weather: CurrentWeather?
    @Published var name: String?
    private var subscriptions = Set<AnyCancellable>()
    
    init(name: String) {
        WeatherDataManager.currentWeatherPublisher(name: name)
            .map(CurrentWeather.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { response in
                switch response {
                case .failure(let error):
                    print("Failed with error: \(error)")
                    return
                case .finished:
                    print("Succeesfully finished!")
                }
            }, receiveValue: { value in
                self.weather = value
            })
            .store(in: &self.subscriptions)
        
    }
}
