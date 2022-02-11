//
//  LocationManager.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import Foundation
import CoreLocation
import Combine

// TODO: Auth handling

class LocationDataManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var weather: LocalWeather?
    @Published var countryName: String?
    @Published var cityName: String?
    @Published var coord: CLLocationCoordinate2D?
    @Published var locationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        DispatchQueue.global(qos: .utility).async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        }
    }
    
    func setCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func setRandomLocation() {
        let randLat = Int.random(in: -90...90)
        let randLon = Int.random(in: -180...180)
        
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(randLat),
                                            longitude: CLLocationDegrees(randLon))
        
        self.coord = coord
        print("HRHRHR \(self.coord)")
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        getLocationName(location)
        getLocalWeather(location)
    }
    
    private func getLocalWeather(_ location: CLLocation) {
        WeatherDataManager.localWeatherPublisher(lon: location.coordinate.longitude,
                                                 lat: location.coordinate.latitude)
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
    
    private func getLocationName(_ location: CLLocation) {
        var city: String?
        var country: String?
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US")) { placemark, error in
            guard let placemark = placemark, error == nil else {
                print("Error occured: \(error!)")
                return
            }
            country = placemark.first?.country
            city = placemark.first?.administrativeArea
            let parsedCountry = country ?? "maybe..."
            let parsedCity = city ?? "No man's land"
            
            self.cityName = parsedCity
            self.countryName = parsedCountry
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.global(qos: .utility).async {
            self.getLocationName(location)
            self.getLocalWeather(location)
        }
        self.coord = location.coordinate
    }
}
