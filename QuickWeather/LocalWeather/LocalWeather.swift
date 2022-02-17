//
//  LocalWeather.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import Foundation
import SwiftUI
import MapKit
import Combine

struct LocalWeatherResponse: Codable {
    let current: Current
    let lat: Double
    let lon: Double
    let timezoneOffset: Int
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case current
        case timezoneOffset = "timezone_offset"
    }
    
    struct Current: Codable {
        let temperature: Double
        let feelsLike: Double
        let humidity: Int
        let pressure: Int
        let windSpeed: Double
        let weather: [Weather]
        
        struct Weather: Codable {
            let main: String
            let iconName: String
            
            enum CodingKeys: String, CodingKey {
                case main
                case iconName = "icon"
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case humidity
            case pressure
            case windSpeed = "wind_speed"
            case weather
        }
    }
    
}


class LocalWeather: ObservableObject {
    @Published var icon: Image?
    private let item: LocalWeatherResponse
    var subscriptions = Set<AnyCancellable>()
    
    private func toCelcius(from kelvin: Double) -> Double {
        return kelvin - 273.15
    }
    
    private func toFerenheit(from kelvin: Double) -> Double {
        return 1.8 * (kelvin - 273) + 32
    }
    
    var weather: String {
        return item.current.weather[0].main
    }
    
    var weatherIconAddress: URL {
        return URL(string: "https://openweathermap.org/img/w/\(item.current.weather[0].iconName).png")!
    }
    
    var speed: String {
        return String(format: "%.1f", item.current.windSpeed)
    }
    
    var celcius: String {
        let celcius = toCelcius(from: item.current.temperature)
        return String(format: "%.1f", celcius)
    }
    
    var ferenheit: String {
        let ferenheit = toFerenheit(from: item.current.temperature)
        return String(format: "%.1f", ferenheit)
    }
    
    var temperatureFeelsLike: String {
        let celcius = toCelcius(from: item.current.feelsLike)
        return String(format: "%.1f", celcius)
    }
    
    var humidity: String {
        return String(format: "%d", item.current.humidity)
    }
    
    var pressure: String {
        return String(format: "%d", item.current.pressure)
    }
    
    init(item: LocalWeatherResponse) {
        self.item = item
        
        let session = URLSession.shared
        let url = URL(string: "https://openweathermap.org/img/w/\(item.current.weather[0].iconName).png")!
        session.dataTask(with: url) { data, response, error in
            if error == nil, let data = data {
                let downloadedImage = UIImage(data: data)!
                DispatchQueue.main.async {
                    self.icon = Image(uiImage: downloadedImage)
                }
            }
            else {
                print("Error while downloading icon image data")
                return
            }
        }
        .resume()
    }
}
