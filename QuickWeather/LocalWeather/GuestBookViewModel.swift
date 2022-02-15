//
//  GuestBookViewModel.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/14.
//

import Foundation
import MapKit



class GuestBookViewModel: ObservableObject {
    @Published var locationName: String
    @Published var location: CLLocationCoordinate2D
    @Published var notes: [Note]
    
    func addNote() {
        
    }
    
    init(name: String, location: CLLocationCoordinate2D, notes: [Note]) {
        self.locationName = name
        self.location = location
        self.notes = notes
    }
}

