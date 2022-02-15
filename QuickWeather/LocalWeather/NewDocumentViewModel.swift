//
//  NewDocumentViewModel.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/15.
//

import SwiftUI
import MapKit

class NewDocumentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var message: String = ""
    @Published var isUploading = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func submit(_ location2D: CLLocationCoordinate2D) {
        self.isUploading = true
        let location = CLLocation(latitude: CLLocationDegrees(location2D.latitude),
                                  longitude: CLLocationDegrees(location2D.longitude))
        let texts = self.message
        let writer = self.name
        
        if self.name.isEmpty || self.message.isEmpty {
            self.showAlert = true
            self.alertMessage = "Texts must not be emtpy"
            return
        }
        
        if self.name.count > 15  {
            self.showAlert = true
            self.alertMessage = "Name must not exceed 15 letters"
            return
        }
        
        if self.message.count > 50  {
            self.showAlert = true
            self.alertMessage = "Message must not exceed 50 letters"
            return
        }
        
        let note = Note(texts: texts, writer: writer, time: Date())
        
        FireStoreManager.addData(location, note) { result in
            switch result {
            case true:
                self.isUploading = false
            case false:
                self.isUploading = true
            }
            self.isUploading = false
        }
    }
}
