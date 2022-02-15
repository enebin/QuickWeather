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
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func submit(_ location2D: CLLocationCoordinate2D) {
        self.isUploading = true
        let location = CLLocation(latitude: CLLocationDegrees(location2D.latitude),
                                  longitude: CLLocationDegrees(location2D.longitude))
        let texts = self.message
        let writer = self.name
        
        if self.name.isEmpty || self.message.isEmpty {
            self.showAlert = true
            self.alertTitle = "Oops!"
            self.alertMessage = "Texts must not be emtpy"
            self.isUploading = false

            return
        }
        
        if self.name.count > 20  {
            self.showAlert = true
            self.alertTitle = "Oops!"
            self.alertMessage = "Name must not exceed 15 letters"
            self.isUploading = false

            return
        }
        
        if self.message.count > 50  {
            self.showAlert = true
            self.alertTitle = "Oops!"
            self.alertMessage = "Message must not exceed 50 letters"
            self.isUploading = false

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
            
            self.name = ""
            self.message = ""
            
            self.showAlert = true
            self.alertTitle = "Cool!"
            self.alertMessage = "Successfully uploaded!"
            self.isUploading = false

            print("Doc successfully uploaded")
        }
    }
    
    private func showAlertRoutine(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
        self.isUploading = false
    }
}
