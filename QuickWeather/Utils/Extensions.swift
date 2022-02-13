//
//  View+Extensions.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/03.
//

import SwiftUI

extension View {
    // https://stackoverflow.com/questions/56505528/swiftui-update-navigation-bar-title-color
    
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().tintColor = uiColor
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}

extension Font {
    struct Arial {
        let subtitle = Font.custom("Arial-BoldMT", size: 12)
        let cityname = Font.custom("ArialCEMTBlack-Regular", size: 25)
        let cardtitle = Font.custom("Arial-BoldMT", size: 15)
        let description = Font.custom("Arial-BoldMT", size: 20)
    }
    
    static let arial = Arial()
}
