//
//  GuestBookView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/14.
//

import SwiftUI

struct GuestBookView: View {
    @ObservedObject var viewModel: GuestBookViewModel
    typealias CardView = LocationView.CardView
    
    init(viewModel: GuestBookViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(red: 248/255, green: 248/255, blue: 248/255)
                .ignoresSafeArea()
                
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Guest book")
                                .font(.arial.cityname)
                                .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))

                            Button(action: {}) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        }
                        .padding(.top, 50)
                        
                        Text("Around \(viewModel.locationName)(\(String(format:"%.1f", viewModel.location.longitude))º, \(String(format:"%.1f", viewModel.location.latitude))º)")
                            .font(.arial.subtitle)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                        
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                    }
                }
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .center, spacing: 25) {
                        if viewModel.notes.isEmpty {
                            Spacer()
                            Text("Looks like\n you've found a new land")
                                .font(.arial.description)
                                .foregroundColor(.gray.opacity(0.5))
                            Image(systemName: "map")
                                .frame(width: 156, height: 156)
                                .scaledToFit()
                                .foregroundColor(.gray.opacity(0.5))
                                .rotationEffect(Angle(degrees: -14.5))
                            
                            Text("Leave a mark")
                                .font(.arial.description)
                            
                            Spacer()
                        } else {
                            ForEach(viewModel.notes, id: \.self) { note in
                                CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                                    .frame(height: 110)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 35)
        }
    }
}

extension GuestBookView {
    var defaultView: some View {
        Group {
            HStack {
                VStack {
                    HStack {
                        Text("Guest book")
                            .font(.arial.cityname)
                            .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))

                        Button(action: {}) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.gray.opacity(0.5))
                        }
                    }
                    .padding(.top, 50)
                    
                    Text("HongKong, 32.1723º, 127.292º")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                    
                Button(action: {}) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                    CardView(category: "2021.02.21", note: "\"Veni vidi vici\"", subtitle: "by Caesar")
                        .frame(height: 110)
                }
            }
            
        }
    }
}
//
//struct GuestBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuestBookView()
//    }
//}
