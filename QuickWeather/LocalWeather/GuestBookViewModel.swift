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
    
    var numberOfPages: Int {
        if self.notes.isEmpty {
            return 0
        }
        
        return Int(ceil(Double((self.notes.count)) / 10.0))
    }
    
    var pagedNotes: [Note] {
        if self.notes.isEmpty {
            return []
        }
        
        let startIndex = (self.page - 1) * 10
        let endIndex = min(self.page * 10 - 1, notes.count-1)
        print(startIndex, endIndex)
        return Array(notes[startIndex...endIndex])
    }
    
    init(name: String, location: CLLocationCoordinate2D, notes: [Note]) {
        self.locationName = name
        self.location = location
        self.notes = notes
    }
}

