//
//  GuestBookViewModel.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/14.
//

import Foundation
import MapKit
import Firebase

struct GuestBookNote: Codable {
    let texts: String
    let time: String
    let writer: String
}

class GuestBookViewModel: ObservableObject {
    @Published var locationName: String
    @Published var location: CLLocationCoordinate2D
    @Published var notes: [String]
    private var db: Firestore

    init(name: String, location: CLLocationCoordinate2D) {
        self.locationName = name
        self.location = location
        self.notes = []
        
        self.db = Firestore.firestore()
        let documentKey = "\(String(format: "%.0f", location.latitude))\(String(format: "%.0f", location.longitude))"
        let document = db.collection("locations").document(documentKey)
        
        document.getDocument { docSnapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            if let docSnapshot = docSnapshot {
                if docSnapshot.exists {
                    print("exists")
                } else {
                    document.setData([:])
                    print("doc made")
                }
            }
            
        }
    }
}

