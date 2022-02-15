//
//  GuestBookViewModel.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/14.
//

import Foundation
import MapKit
import Firebase

struct Note: Codable, Identifiable {
    var id = UUID()
    let texts: String
    let writer: String
    let time: Date
    
    var date: String {
        yearMonthDayFormatter.string(from: self.time)
    }
    
    init(texts: String, writer: String, time: Date) {
        self.texts = texts
        self.writer = writer
        self.time = time
    }
}

class GuestBookViewModel: ObservableObject {
    @Published var locationName: String
    @Published var location: CLLocationCoordinate2D
    @Published var notes: [Note]?
    private var db: Firestore
    
    func addNote() {
        
    }

    init(name: String, location: CLLocationCoordinate2D) {
        self.locationName = name
        self.location = location
        
        self.db = Firestore.firestore()
        let documentKey = "\(String(format: "%.0f", location.latitude)).\(String(format: "%.0f", location.longitude))"
        let document = db.collection("locations").document(documentKey)
        
        document.getDocument { docSnapshot, error in
            if let error = error {
                print(error)
                return
            }
            
            if let docSnapshot = docSnapshot {
                if docSnapshot.exists {
                    print("exists")
                    docSnapshot.reference.collection("notes").getDocuments { doc, error in
                        if let error = error {
                            print(error)
                            return
                        }
                        
                        if let doc = doc {
                            self.notes = doc.documents.compactMap({ snap in
                                return Note(texts: snap.get("texts") as! String,
                                            writer: snap.get("writer") as! String,
                                            time: (snap.get("time") as! Timestamp).dateValue()
                                )
                            })
                        }
                    }
                } else {
                    document.setData([:])
                    self.notes = []
                    print("doc made")
                }
            }
        }
    }
}

