//
//  LocationView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/13.
//

import SwiftUI

struct LocationView: View {
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 248/255, blue: 248/255)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray)
                    .frame(height: 142)
                    .padding(.bottom, 18)
                
                Text("It seems you're at")
                    .font(.arial.subtitle)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("HongKong")
                        .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                    Spacer()
                    
                    Image(systemName: "arrow.clockwise")
                    Image(systemName: "square.and.arrow.up")
                }
                .padding(.bottom, 48)
                
                Text("Details about them")
                    .font(.arial.subtitle)
                    .foregroundColor(.gray)
                    .padding(.bottom, 18)
                
                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        CardView(category: "Weather", note: "23ºC", subtitle: "Cloudy")
                            .frame(height: 110)
                        CardView(category: "Time", note: "PM 1:23", subtitle: nil)
                            .frame(height: 110)
                    }
                    CardView(category: "Location", note: "Asia", subtitle: "32.1723º, 127.292º")
                        .frame(height: 110)
                    CardView(category: "Guest book", note: "\"Veni vidi vici\"", subtitle: "21.02.21 22: 34 by Caesar")
                        .frame(height: 110)
                }
                
                
            }
            .padding(.horizontal, 20)
        }
    }
}

extension LocationView {
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
                .padding(.horizontal, 23)
                Spacer()
            }
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
