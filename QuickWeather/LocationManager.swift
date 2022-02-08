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

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    
    @Published var locationName: String?
    @Published var longitude: Double?
    @Published var latitude: Double?
    @Published var locationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        DispatchQueue.global(qos: .utility).async {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func getLocationName(_ location: CLLocation, completion: @escaping (String?) -> Void) {
        var name: String?
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US")) { placemark, error in
            guard let placemark = placemark, error == nil else {
                print(error!)
                return
            }
            name = placemark.first?.administrativeArea
            completion(name)
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

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.global(qos: .utility).async {
                self.getLocationName(location) { result in
                    guard let result = result else {
                        print("Error while loading location")
                        return
                    }
                    DispatchQueue.main.async {
                        self.locationName = result
                    }
                }
        }
        
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
    }
}
