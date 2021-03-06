//
//  LocationView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/13.
//

import SwiftUI
import StoreKit

struct LocationView: View {
    @EnvironmentObject var viewModel: LocationDataManager
    @EnvironmentObject var setting: Setting
    @StateObject var timeManager = TimeManager()

    @State var pulseParameter = true
    @State var showNewDocSheet = false
    @State var showSetting = false
    @State var showNoticeAlert = false
    @State var showExpiredAlert = false
    @State var showNetworkError = false
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                if let weather = viewModel.weather,
                   let coord = viewModel.coord,
                   let cityName = viewModel.cityName,
                   let countryName = viewModel.countryName,
                   let time = viewModel.time,
                   let notes = viewModel.notes
                {
                    HStack {
                        Spacer()
                        Button(action: { showSetting = true }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                        }
                    }
                    .padding(.top, 5)
                    
                    Spacer()
                    
                    MapView(location: coord)
                        .frame(height: 142)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                        .padding(.bottom, 18)
                        .alert(isPresented: $showNoticeAlert) {
                            noticeAlert
                        }
                        .onAppear {
                            if setting.isFirstExecution {
                                self.showNoticeAlert = true
                            }
                        }
                    
                    Text("It seems you're at")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("\(cityName)")
                            .font(.arial.cityname)
                            .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                        
                        functionalButtons
                            .alert(isPresented: $showExpiredAlert) {
                                expiredAlert
                            }
                    }
                    .padding(.bottom, 48)
                    
                    Text("More about the place")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                        .padding(.bottom, 18)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            CardView(category: "Weather",
                                     note: setting.tempType == .celcius ? "\(weather.celcius)ºC" : "\(weather.ferenheit)ºF",
                                     subtitle: "\(weather.weather)")
                                .frame(height: 110)
                            CardView(category: "Time", note: "\(time)", subtitle: nil)
                                .frame(height: 110)
                        }
                        CardView(category: "Location", note: "\(countryName)", subtitle: "\(String(format: "%.1f", coord.latitude))º, \((String(format: "%.1f", coord.longitude)))º")
                            .frame(height: 110)
                        GuestCardView(note: notes.first?.texts,
                                      subtitle: "\(notes.first?.date ?? "") by \(notes.first?.writer ?? "")")
                            .frame(height: 110)
                            .onTapGesture {
                                showNewDocSheet = true
                            }
                    }
                    .sheet(isPresented: $showSetting, onDismiss: {}) {
                        SettingView(showSheet: $showSetting).environmentObject(viewModel)
                    }
                    .sheet(isPresented: $showNewDocSheet, onDismiss: {
                        showNewDocSheet = false
                        viewModel.loadNotes()
                    }) {
                        GuestBookView(viewModel: GuestBookViewModel(name: cityName, location: coord, notes: notes),
                                      showSheet: $showNewDocSheet)
                    }
                    
                    Spacer()

                } else if viewModel.isOnline == false {
                    askForOnline
                } else {
                    if !showNetworkError {
                        defaultView
                            .opacity(pulseParameter ? 1 : 0.5)
                            .onAppear {
                                withAnimation(self.repeatingAnimation) {
                                    self.pulseParameter.toggle()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//                                    self.showNetworkError = true
                                }
                            }
                    } else {
                        askForOnline
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

extension LocationView {
    var background: some View {
        Color(red: 248/255, green: 248/255, blue: 248/255)
    }
    
    var reload: some View {
        Button(action: { viewModel.setCurrentLocation() }) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Reload")
            }
        }
        .foregroundColor(.black)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1.5))
    }
    
    var askForOnline: some View{
        Group {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Text("Error")
                    .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                    .padding(.vertical)
                
                Text("Network seems unstable.\nPlease check you connection and try again!")
                    .font(.arial.description)
                    .lineSpacing(3)
                    .padding(.bottom, 30)
                
                HStack {
                    Spacer()
                    reload
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
    var noticeAlert: Alert {
        Alert(title:
                Text("Notice"),
              message:
                Text("Welcome to WeatherVenture! You can travel around the world with this app and come across with the marks left by a pioneer who's already visited the spot you stop by. \n Unfortunately, for now, only 30 reloads are allowed per day. You can check your remaining chances in the setting. I'll offer more chances when I can afford more server cost. Sorry 🥲"),
              dismissButton:
                    .default(Text("Don't show again"),
                             action: { setting.setIsFirstExecutionFalse()
        })
        )
    }
    
    var expiredAlert: Alert {
        Alert(title: Text("Notice"),
              message: Text("You have used all of your chances. You have to wait until "),
              dismissButton: .default(Text("Ok"))
        )
    }
    
    var repeatingAnimation: Animation {
        Animation
            .linear(duration: 1)
            .repeatForever()
    }
    
    var sheetContent: some View {
        Text("Coming soon")
            .font(.title)
    }
        
    var functionalButtons: some View {
        Group {
            Button(action: {
                self.showNetworkError = false

                if setting.remainingChances <= 0 {
                    showExpiredAlert = true
                    setting.checkFirstToday()
                } else {
                    viewModel.setRandomLocation()
                    timeManager.waitUntilNextChance()
                    setting.setRemainingChancesDecreased()
                }
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .foregroundColor(.black)
            .disabled(!timeManager.isActive)
            
            Spacer()
            
            Button(action: {
                self.showNetworkError = false

                timeManager.waitUntilNextChance()
                viewModel.setCurrentLocation()
            }) {
                Image(systemName: "scope")
            }
            .foregroundColor(.black)
            .disabled(!timeManager.isActive)

//            Button(action: { }) {
//                Image(systemName: "square.and.arrow.up")
//            }
            .foregroundColor(.black)
            
        }
    }
    
    var defaultView: some View {
        Group {
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.3))
                .frame(height: 142)
                .padding(.bottom, 18)
                        
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.3))
                .frame(width: 99, height: 14)
                .padding(.bottom, 2)
            
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.3))
                    .frame(width: 142, height: 35)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.3))
                    .frame(width: 70, height: 35)
            }
            .padding(.bottom, 48)
            
            RoundedRectangle(cornerRadius: 15)
                .fill(.gray.opacity(0.3))
                .frame(width: 108, height: 14)
                .padding(.bottom, 18)
            
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                }
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.3))
                    .frame(height: 110)

                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.3))
                    .frame(height: 110)
            }
        }
    }
    
    struct GuestCardView: View {
        let note: String?
        let subtitle: String?
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Guest book")
                        .font(.arial.cardtitle)
                        .foregroundColor(Color(red: 185/255, green: 212/255, blue: 82/255))
                        .padding(.top, 14)
                        .padding(.bottom, subtitle == nil ? 15 : 10)
                         
                    if let note = note, let subtitle = subtitle {
                        Text("\"\(note)\"")
                            .font(.arial.description)
                        
                        Text(subtitle)
                            .font(.arial.subtitle)
                            .foregroundColor(.gray)
                    } else {
                        Text("No one's ever been here")
                            .font(.arial.description)
                            .foregroundColor(.gray)
                        Text("How about leaving footprints?")
                            .font(.arial.subtitle)
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    
                    Spacer()
                }
                Spacer()
                
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 23)
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
            )
        }
    }

    struct CardView: View {
        let category: String
        let note: String
        let subtitle: String?
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(category)
                        .font(.arial.cardtitle)
                        .foregroundColor(Color(red: 185/255, green: 212/255, blue: 82/255))
                        .padding(.top, 14)
                        .padding(.bottom, subtitle == nil ? 16 : 13)
                    
                    Text(note)
                        .font(.arial.description)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.arial.subtitle)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, 23)
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(.white)
                            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
            )
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
