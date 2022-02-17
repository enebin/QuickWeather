//
//  SettingView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/17.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var setting: Setting
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Setting")
                    .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                    .padding(.vertical, 10)
                                
                tempUnit
                
                Spacer()

                HStack {
                    Spacer()
                    VStack {
                        Text("Art of blank space")
                            .font(.arial.cityname)
                        Text("It will be full... someday...")
                            .font(.arial.subtitle)
                    }
                    .foregroundColor(.gray.opacity(0.3))

                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    doneButton
                }
            }
            .padding(.horizontal, 35)
        }
    }
}

extension SettingView {
    var tempUnit: some View {
        VStack(alignment: .leading) {
            Text("Temperature unit")
                .font(.arial.subtitle)
            Picker("TempType", selection: $setting.tempType) {
                Text(Setting.TemperatureType.celcius.rawValue)
                    .tag(Setting.TemperatureType.celcius)
                Text(Setting.TemperatureType.ferenheit.rawValue)
                    .tag(Setting.TemperatureType.ferenheit)
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var doneButton: some View {
        Button(action: { showSheet = false }) {
            Text("Done")
                .bold()
                .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(showSheet: .constant(false))
    }
}
