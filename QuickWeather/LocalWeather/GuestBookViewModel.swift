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
    @Published var page = 1
    
    var pagedNotes: [Note] {
        if self.notes.isEmpty {
            return []
        }
        
        return Array(notes[0...min(self.page * 10, notes.count-1)])
    }
    
    init(name: String, location: CLLocationCoordinate2D, notes: [Note]) {
        self.locationName = name
        self.location = location
        self.notes = notes
    }
}

