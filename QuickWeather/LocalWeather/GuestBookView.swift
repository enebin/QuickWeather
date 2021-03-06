//
//  GuestBookView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/14.
//

import SwiftUI

struct GuestBookView: View {
    @ObservedObject var viewModel: GuestBookViewModel
    
    @State var showReportAlert = false
    @State var pulseParameter = false
    @Binding var showSheet: Bool
    typealias CardView = LocationView.CardView
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                    .ignoresSafeArea()
                    
                VStack(alignment: .leading, spacing: 0) {
                    if let notes = viewModel.notes {
                        header
                            .padding(.bottom, 35)

                        if notes.isEmpty {
                           emptyView
                        } else {
                            Text("\(viewModel.notes.count) pioneers left their mark")
                                .font(.arial.cardtitle)
                                .foregroundColor(.gray)
                                .padding(.bottom, 12)
                            
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .center, spacing: 25) {
                                    ForEach(viewModel.pagedNotes, id: \.id) { note in
                                        ZStack {
                                            CardView(category: "\(note.date)", note: "\"\(note.texts)\"", subtitle: "by \(note.writer)")
                                            VStack {
                                                Spacer()
                                                HStack(spacing: 2) {
                                                    Spacer()
                                                    Button(action:{ showReportAlert = true }) {
                                                        Image(systemName: "flag")
                                                        Text("report")
                                                    }
                                                    .alert(isPresented: $showReportAlert) {
                                                        Alert(title: Text("Notice"),
                                                              message: Text("Thanks for your contribution! We will take care of it as soon as possible."),
                                                              dismissButton: .default(Text("Ok"))
                                                        )
                                                    }
                                                }
                                            }
                                            .font(.arial.subtitle)
                                            .foregroundColor(.gray.opacity(0.5))
                                            .padding()
                                        }
                                        .frame(height: 110)
                                    }
                                    
                                    HStack {
                                        let startIndex = max(1, viewModel.page-2)
                                        let endIndex = min(viewModel.page+2, viewModel.numberOfPages)
                                        ForEach((startIndex...endIndex), id: \.self) { num in
                                            Button(action: {viewModel.page = num}) {
                                                Text(String(num))
                                                    .foregroundColor(viewModel.page == num ? .black : .gray)
                                                    .fontWeight(viewModel.page == num ? .bold : .regular)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        defaultView
                        .onAppear {
                            withAnimation(self.repeatingAnimation) {
                                self.pulseParameter.toggle()
                            }
                        }
                    }
                }
                .padding(.horizontal, 35)
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                toolbarItems
            }
        }
        .accentColor(Color(red: 80/255, green: 91/255, blue: 106/255))
    }
}

extension GuestBookView {
    var repeatingAnimation: Animation {
        Animation
            .linear(duration: 1)
            .repeatForever()
    }
    
    var toolbarItems: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showSheet = false }) {
                    Image(systemName: "xmark")
                }
                .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
            }
        }
    }
    
    var background: some View {
        Color(red: 248/255, green: 248/255, blue: 248/255)
    }
    
    var header: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Guest book")
                        .font(.arial.cityname)
                        .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                    
                    //                    .padding(.top, 50)
                    
                    Text("Around \(viewModel.locationName)(\(String(format:"%.1f", viewModel.location.longitude))º, \(String(format:"%.1f", viewModel.location.latitude))º)")
                        .font(.arial.subtitle)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                NavigationLink(destination: NewDocumentView(showSheet: $showSheet).environmentObject(viewModel)
                ) {
                    Image(systemName: "plus")
                        .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                }
            }
        }
    }
    
    var emptyView: some View {
        Group {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 15) {
                    Spacer()

                    Text("Looks like\n you've found a new land")
                        .multilineTextAlignment(.center)
                        .font(.arial.description)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.bottom, 50)
                    Image(systemName: "map")
                        .resizable()
                        .font(.title.weight(.light))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.5))
                        .rotationEffect(Angle(degrees: -14.5))
                    Spacer()
                    
                    NavigationLink(destination:
                                    NewDocumentView(showSheet: $showSheet).environmentObject(viewModel)
                    ) {
                        Text("Leave a messsage")
                            .foregroundColor(.white)
                            .font(.arial.light)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 185/255, green: 212/255, blue: 82/255))
                                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                            )
                        
                    }
                    .foregroundColor(.black)

                    Spacer()
                    
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    var defaultView: some View {
        Group {
            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(width: 160, height: 35)
                    .padding(.top, 50)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(width: 170, height: 15)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 25) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.3))
                        .frame(height: 110)
                }
            }
            
        }
    }
}
//
//import MapKit
//struct GuestBookView_Previews: PreviewProvider {
//    static var previews: some View {
//        GuestBookView(viewModel: GuestBookViewModel(name: "Dummy", location: CLLocationCoordinate2D(latitude: CLLocationDegrees(20), longitude: CLLocationDegrees(20))))
//    }
//}
