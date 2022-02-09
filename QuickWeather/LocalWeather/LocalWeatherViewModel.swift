//
//  LocalWeatherViewModel.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import SwiftUI
import MapKit
import Combine

class LocalWeatherViewModel: ObservableObject {
    @Published var weather: LocalWeather?
    @Published var coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var subscriptions = Set<AnyCancellable>()
    
    private func updateWeather(coord: CLLocationCoordinate2D) {
        WeatherDataManager.localWeatherPublisher(lon: coord.longitude, lat: coord.latitude)
            .map(LocalWeather.init)
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
    
    init(coord: CLLocationCoordinate2D) {
        self.updateWeather(coord: coord)
        self.$coord.sink(receiveValue: { _ in
            self.updateWeather(coord: coord)
        })
            .store(in: &subscriptions)
        self.coord = coord
    }
}
