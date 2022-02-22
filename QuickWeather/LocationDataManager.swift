//
//  LocationManager.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import Foundation
import CoreLocation
import Network
import Combine

// TODO: Auth handling

class LocationDataManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetConnectionMonitor")
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isOnline: Bool?
    @Published var weather: LocalWeather?
    @Published var countryName: String?
    @Published var cityName: String?
    @Published var coord: CLLocationCoordinate2D?
    @Published var time: String?
    @Published var notes: [Note]?
    @Published var isCurrentPosition = true
    @Published var locationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        DispatchQueue.global(qos: .userInitiated).async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        }
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                DispatchQueue.main.async { 
                    self.isOnline = true
                    self.locationManager.requestLocation()
                }
            } else {
                DispatchQueue.main.async {
                    self.isOnline = false
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    func setCurrentLocation() {
        self.weather = nil
        self.countryName = nil
        self.cityName = nil
        self.time = nil
        self.notes = nil
        self.isCurrentPosition = true
        
        locationManager.requestLocation()
    }
    
    func setRandomLocation() {
        self.weather = nil
        self.countryName = nil
        self.cityName = nil
        self.time = nil
        self.notes = nil
        self.isCurrentPosition = false
        
        let randLat = Int.random(in: -900...900)
        let randLon = Int.random(in: -1800...1800)
        
        let coord = CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(randLat)/10.0),
                                           longitude: CLLocationDegrees(Double(randLon)/10.0))
        
        self.coord = coord
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        getLocationNameAndTime(location)
        getLocalWeather(location)
        loadNotes(location)
    }
    
    func loadNotes(_ location: CLLocation? = nil) {
        guard let lat = coord?.latitude, let lon = coord?.longitude else { return }
        var loc = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))

        if location != nil {
            loc = location!
        }
        
        FireStoreManager.loadData(loc) { notes in
            self.notes = notes.sorted { $0.time > $1.time } 
        }
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
    
    private func getLocationNameAndTime(_ location: CLLocation) {
        var city: String?
        var country: String?
        var time: TimeZone?
        
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US")) { placemark, error in
            guard let placemark = placemark, error == nil else {
                print("Error occured: \(error!)")
                return
            }
            country = placemark.first?.country
            city = placemark.first?.administrativeArea
            time = placemark.first?.timeZone
                        
            let parsedCountry = country ?? "Far far away..."
            let parsedCity = city ?? "No man's land"
            let parsedTime = self.timeCalcultor(tz: time)
            
            self.cityName = parsedCity
            self.countryName = parsedCountry
            self.time = parsedTime
        }
    }
    
    private func timeCalcultor(tz: TimeZone?) -> String {
        let date = DateFormatter()
        
        if let tz = tz {
            date.timeZone = tz
            date.amSymbol = "AM"
            date.pmSymbol = "PM"
            date.dateFormat = "a h:mm"
            
            return date.string(from: Date())
        } else {
            return "Hmm.. where are you?"
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.getLocationNameAndTime(location)
            self.getLocalWeather(location)
            self.loadNotes(location)

        }
        self.coord = location.coordinate
    }
}
