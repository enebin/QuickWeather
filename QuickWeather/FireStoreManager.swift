//
//  FireStoreManager.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/15.
//

import SwiftUI
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

class FireStoreManager {
    static var db = Firestore.firestore()
    
    static func loadData(_ location: CLLocation, completion: @escaping ([Note]) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let documentKey = "\(String(format: "%.0f", latitude)).\(String(format: "%.0f", longitude))"
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
                            let notes = doc.documents
                                .compactMap { snap in
                                    return Note(texts: snap.get("texts") as! String,
                                                writer: snap.get("writer") as! String,
                                                time: (snap.get("time") as! Timestamp).dateValue())
                                }
                            
                            completion(notes)
                        }
                    }
                } else {
                    document.setData([:])
                    print("doc made")
                    
                    completion([])
                }
            }
        }
    }
    
    static func addData(_ location: CLLocation, _ note: Note, completion: @escaping (Bool) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let documentKey = "\(String(format: "%.0f", latitude)).\(String(format: "%.0f", longitude))"
        let locationDocument = db.collection("locations").document(documentKey)
        
        locationDocument.getDocument { locationDocSnap, error in
            if let error = error {
                print(error)
                completion(false)
                return
            }
            
            if let locationDocSnap = locationDocSnap {
                if !locationDocSnap.exists {
                    print("Doc doesn't exist")
                    completion(false)
                    return
                }
                
                locationDocSnap.reference
                    .collection("notes")
                    .addDocument(data: ["texts" : note.texts, "writer" : note.writer, "time" : Timestamp(date: note.time)]) { error in
                        if let error = error {
                            print(error)
                            completion(false)
                            return
                        }
                    }
            }
        }
        
        completion(true)
    }
    
    static func reload(_ location: CLLocation, _ note: Note, completion: @escaping (Bool) -> Void) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let documentKey = "\(String(format: "%.0f", latitude)).\(String(format: "%.0f", longitude))"
        let locationDocument = db.collection("locations").document(documentKey)
    }
}
