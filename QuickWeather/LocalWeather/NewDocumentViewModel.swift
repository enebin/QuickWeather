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
    
    @Published var isFirst = true
    
    init() {
        let userDefaultKey = "isFirstNewDoc"
        let userDefaultIsFirst = UserDefaults.standard.object(forKey: userDefaultKey)
        
        if userDefaultIsFirst == nil {
            UserDefaults.standard.set(true, forKey: userDefaultKey)
        } else {
            self.isFirst = userDefaultIsFirst as! Bool
        }
    }
    
    func submit(_ location2D: CLLocationCoordinate2D) {
        self.isUploading = true
        let location = CLLocation(latitude: CLLocationDegrees(location2D.latitude),
                                  longitude: CLLocationDegrees(location2D.longitude))
        let texts = self.message
        let writer = self.name
        
        if self.name.isEmpty || self.message.isEmpty {
            showAlertRoutine(title: "Oops!", message: "Texts must not be emtpy")

            return
        }
        
        if self.name.count > 20  {
            showAlertRoutine(title: "Oops!", message: "Name must not exceed 20 letters")

            return
        }
        
        if self.message.count > 50  {
            showAlertRoutine(title: "Oops!", message: "Message must not exceed 50 letters")

            return
        }
        
        let note = Note(texts: texts, writer: writer, time: Date())
        FireStoreManager.addData(location, note) { result in
            switch result {
            case true:
                self.name = ""
                self.message = ""
                
                self.showAlertRoutine(title: "Cool!", message: "Successfully uploaded!")
            case false:
                self.showAlertRoutine(title: "Oops!", message: "Something went wrong... Please try again in a minute.")
            }
            print("Doc successfully uploaded")
        }
    }
    
    func showAlertRoutine(title: String, message: String) {
        self.showAlert = true
        self.alertTitle = title
        self.alertMessage = message
        self.isUploading = false
    }
}
