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
    @ObservedObject var storeManager = StoreManager()
    
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
                Divider()
                
                // 남은 리로드 가능 개수
                remainingChances
                Divider()
                
                // 도네
                // TODO: IAP로 바꾸기
                buyMeAServer
                
                Spacer()

                // 빈칸 채우기
                filler
                
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
    var filler: some View {
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
    }
    
    var buyMeAServer: some View {
        VStack(alignment: .leading) {
            Text("Buy me a server")
                .font(.arial.subtitle)
                .padding(.bottom, 10)
                .alert(isPresented: $storeManager.showSuccessAlert) {
                    Alert(title: Text("Success!"),
                          message: Text("Your chances are reset. Thanks for your purchase."),
                          dismissButton: .default(Text("Ok"), action: { setting.setRemainingChancesFull() })
                    )
                }
            
            HStack {
                Spacer()
                if (storeManager.myProducts.first != nil) && storeManager.transactionState != .purchasing {
                    let product = storeManager.myProducts.first!
                    Button(action: { storeManager.purchaseProduct(product: product) }) {
                        Text("Reset remaining chances(\(storeManager.priceStringForProduct(item: product)!))")
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                            )
                    }
                    .alert(isPresented: $storeManager.showFailureAlert) {
                        Alert(title: Text("Oops!"),
                              message: Text("For some reasons, failed to purchase. Please try again later."),
                              dismissButton: .default(Text("Ok"))
                        )
                    }
                } else {
                    ProgressView()
                }
                Spacer()
            }
        }
    }
    
    var remainingChances: some View {
        VStack(alignment: .leading) {
            Text("Remaining number of spots you can visit today")
                .font(.arial.subtitle)
                .padding(.bottom, 10)

            Text("\(setting.remainingChances)")
                .font(.arial.description)
                .padding(.bottom, 5)
            
            Text("⚠️ Reset every 12AM")
                .font(.arial.subtitle)
                .foregroundColor(.gray)
        }
    }
    
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
