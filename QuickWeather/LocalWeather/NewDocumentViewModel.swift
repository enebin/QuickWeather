//
//  NewDocumentViewModel.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/15.
//

import SwiftUI

class NewDocumentViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var message: String = ""
    
    func submit() {
        
    }
}
