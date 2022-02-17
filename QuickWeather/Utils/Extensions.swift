//
//  View+Extensions.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/03.
//

import SwiftUI

extension Font {
    struct Arial {
        let subtitle = Font.custom("Arial-BoldMT", size: 12)
        let cityname = Font.custom("ArialCEMTBlack-Regular", size: 25)
        let cardtitle = Font.custom("Arial-BoldMT", size: 15)
        let description = Font.custom("Arial-BoldMT", size: 20)
        let light = Font.custom("ArialHebrew", size: 15)
    }
    
    static let arial = Arial()
}
