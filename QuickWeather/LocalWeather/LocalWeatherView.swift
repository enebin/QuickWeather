//
//  LocalWeatherView.swift
//  Weatherman
//
//  Created by 이영빈 on 2022/02/04.
//

import SwiftUI

struct LocalWeatherView: View {
    @ObservedObject var viewModel: LocalWeatherViewModel
    
    var body: some View {
        VStack {
            if let weather = viewModel.weather?.weather {
                Text("\(weather)")
            }
        }
//        Text("\(viewModel.weather!.weather)")
    }
}

//struct LocalWeatherView_Previews: PreviewProvider {
//    static var previews: some View {
//        LocalWeatherView()
//    }
//}
