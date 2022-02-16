//
//  QuickWeatherApp.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/05.
//

import SwiftUI
import Firebase

// TODO: 누르는 횟수 제한 + 스토어 연동하기


@main
struct QuickWeatherApp: App {
    @StateObject var localDataManager = LocationDataManager()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let permission = localDataManager.locationStatus {
                if permission == .denied {
                    askForPermission
                        .padding(.horizontal, 35)
                } else {
                    // Main view
                    LocationView()
                        .environmentObject(localDataManager)
                        .onAppear {
                            localDataManager.setCurrentLocation()
                            print("PRint")
                        }
                }
            }
        }
    }
}

extension QuickWeatherApp {
    var askForPermissionButton: some View {
        func openSetting(){
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
        return Button(action: { openSetting() }) {
            Text("Go to setting")
        }
        .foregroundColor(.white)
        .font(.arial.cardtitle)
        .padding()
        .frame(width: 150)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 185/255, green: 212/255, blue: 82/255))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
        )
    }
    
    var askForPermission: some View {
        Group {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Text("Sorry!")
                    .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                
                Spacer()
                
                Text("If you want to use our app,\nplease give permission to use\nyour location data")
                    .font(.arial.description)
                    .lineSpacing(3)
                    .padding(.bottom, 6)
                Text("Your data is managed safely. Believe us.")
                    .font(.arial.subtitle)
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack {
                    Spacer()
                    askForPermissionButton
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}
