//
//  SettingView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/17.
//

import SwiftUI

/// 톱니바퀴 누르면 나오는 세팅 뷰
struct SettingView: View {
    @EnvironmentObject var setting: Setting
    @Binding var showSheet: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Setting")
                    .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                    .padding(.vertical, 10)
                
                // 화씨와 섭씨를 고를 수 있는 옵션을 제공
                tempUnit
                
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
    var remainingChances: some View {
        Text("\(setting.remainingChances)")
    }
    
    var tempUnit: some View {
        VStack(alignment: .leading) {
            Text("Temperature unit")
                .font(.arial.description)
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
