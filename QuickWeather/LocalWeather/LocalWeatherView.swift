//
//  LocalWeatherView.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import SwiftUI

struct LocalWeatherView: View {
    @ObservedObject var viewModel: LocalWeatherViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    init(viewModel: LocalWeatherViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // Background color. LinearGradient in this case
            Background
                .ignoresSafeArea()
   
            if let weather = viewModel.weather {
                VStack {
                    VStack {
                        Header
                        // Weather description with icon ahead
                        WeatherWithIcon
                        
                        Spacer()
                        
                        MapView(viewModel.coord)
                            .frame(width: 300, height: 300, alignment: .center)
                        
                        // Main Temp
                        Text("\(weather.temperature)º")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
            } else {
                ProgressView()
            }
        }
    }
}

extension LocalWeatherView {
    var Background: some View {
        let startColor: Color
        let endColor: Color
        
        switch viewModel.weather?.weather.lowercased() {
        case "clouds":
            startColor = Color(red: 71/255, green: 110/255, blue: 168/255)
            endColor = Color(red: 173/255, green: 207/255, blue: 246/255)
            break
        case "clear":
            startColor = Color(red: 8/255, green: 102/255, blue: 246/255)
            endColor = Color(red: 173/255, green: 207/255, blue: 246/255)
            break
        case "rain":
            startColor = Color(red: 55/255, green: 55/255, blue: 55/255)
            endColor = Color(red: 149/255, green: 161/255, blue: 174/255)
            break
        case "snow":
            startColor = Color(red: 55/255, green: 55/255, blue: 55/255)
            endColor = Color(red: 149/255, green: 161/255, blue: 174/255)
            break
        default:
            startColor = Color(red: 167/255, green: 210/255, blue: 172/255)
            endColor = Color(red: 95/255, green: 218/255, blue: 108/255)
            break
        }
        
        return LinearGradient(colors: [startColor, endColor],
                              startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    var Header: some View {
        VStack {
            if let name = locationManager.locationName {
                Text("It seems you're at...")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text("\(name)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
    
    var WeatherWithIcon: some View {
        HStack {
            if let viewModel = viewModel.weather, let icon = viewModel.icon {
                icon
                Text("\(viewModel.weather)")
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 25))
    }
    
    /// Only available in CurrentWeather model
//    var MinAndMaxTemp: some View {
//        HStack(spacing: 15) {
//            if let viewModel = viewModel.weather {
//                VStack {
//                    Text("min")
//                        .foregroundColor(.white)
//                    Text("\(viewModel.minTemperature)º")
//                        .foregroundColor(.blue)
//                }
//                VStack {
//                    Text("max")
//                        .foregroundColor(.white)
//                    Text("\(viewModel.maxTemperature)º")
//                        .foregroundColor(.red)
//                }
//            }
//        }
//        .font(.system(size: 25))
//    }
    
    var TempFeelsLike: some View {
        HStack{
            if let viewModel = viewModel.weather {
                VStack(alignment: .leading) {
                    Text("Temperature feels like")
                        .padding(.bottom, 10)
                        .font(.system(size: 20))
                    Text("\(viewModel.temperatureFeelsLike)º")
                        .font(.system(size: 25))
                        .bold()
                }
                Spacer()
            }
        }
        .foregroundColor(.white)
    }
    
    var MoreInformations: some View {
        HStack {
            if let viewModel = viewModel.weather {
                VStack {
                    Text("ATM")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    FigWithUnit(figure: viewModel.pressure, unit: "hPa")
                }
                Spacer()
                VStack {
                    Text("Wind Speed")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    FigWithUnit(figure: viewModel.speed, unit: "m/s")
                    
                }
                Spacer()
                VStack {
                    Text("Humidity")
                        .font(.system(size: 20))
                        .padding(.bottom, 10)
                    FigWithUnit(figure: viewModel.humidity, unit: "%")
                }
            }
        }
        .foregroundColor(.white)
        .font(.system(size: 25))
    }
    
    @ViewBuilder
    func FigWithUnit(figure: String, unit: String) -> some View {
        HStack {
            Text("\(figure)")
                .bold()
            Text("\(unit)")
                .font(.subheadline)
        }
    }
}
