//
//  LocationView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/13.
//

import SwiftUI

struct LocationView: View {
    @EnvironmentObject var viewModel: LocationDataManager
    @StateObject var timeManager = TimeManager()

    @State var pulseParameter = true
    @State var showSheet = false
    
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
                    MapView(location: coord)
                        .frame(height: 142)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                        .padding(.bottom, 18)
                    
                    Text("It seems you're at")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("\(cityName)")
                            .font(.arial.cityname)
                            .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                        
                        functionalButtons
                    }
                    .padding(.bottom, 48)
                    
                    Text("Details about them")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                        .padding(.bottom, 18)
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 16) {
                            CardView(category: "Weather", note: "\(weather.temperature)ºC", subtitle: "\(weather.weather)")
                                .frame(height: 110)
                            CardView(category: "Time", note: "\(time)", subtitle: nil)
                                .frame(height: 110)
                        }
                        CardView(category: "Location", note: "\(countryName)", subtitle: "\(coord.latitude)º, \(coord.longitude)º")
                            .frame(height: 110)
                        CardView(category: "Guest book",
                                 note: "\"\(notes.first?.texts ?? "New spot..")\"",
                                 subtitle: "\(notes.first?.date ?? "") by \(notes.first?.writer ?? "")",
                                 showLink: true)
                            .frame(height: 110)
                            .onTapGesture {
                                showSheet = true
                            }
                    }
                    .sheet(isPresented: $showSheet, onDismiss: { showSheet = false }) {
                        GuestBookView(viewModel: GuestBookViewModel(name: cityName, location: coord, notes: notes))
                    }
                } else {
                    defaultView
                        .opacity(pulseParameter ? 1 : 0.5)
                        .onAppear {
                            withAnimation(self.repeatingAnimation) {
                                self.pulseParameter.toggle()
                            }
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
                viewModel.setRandomLocation()
                timeManager.waitUntilNextChance()
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .foregroundColor(.black)
            .disabled(!timeManager.isActive)
            
            Spacer()
            
            Button(action: { viewModel.setCurrentLocation() }) {
                Image(systemName: "scope")
            }
            .foregroundColor(.black)
            
            Button(action: { }) {
                Image(systemName: "square.and.arrow.up")
            }
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
    

    struct CardView: View {
        let category: String
        let note: String
        let subtitle: String?
        var showLink: Bool = false
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(category)
                        .font(.arial.cardtitle)
                        .foregroundColor(Color(red: 185/255, green: 212/255, blue: 82/255))
                        .padding(.top, 14)
                        .padding(.bottom, subtitle == nil ? 15 : 10)
                    
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
                if showLink {
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(width: 20, height: 20)
                }
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
