//
//  NewDocumentView.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/15.
//

import SwiftUI


struct NewDocumentView: View {
    @EnvironmentObject var source: GuestBookViewModel
    @ObservedObject var viewModel = NewDocumentViewModel()
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                HStack {
                    header
//                        .padding(.top, 50)
                    Spacer()
                }
                
                textFields
                    .padding(.top, 50)
                
                Spacer()
                
               submitButton
                
                Spacer()
            }
            .padding(.horizontal, 35)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

extension NewDocumentView {
    var background: some View {
        Color(red: 248/255, green: 248/255, blue: 248/255)
    }
    
    var header: some View {
        Group {
            VStack(alignment: .leading) {
                Text("New message")
                    .font(.arial.cityname)
                    .foregroundColor(Color(red: 80/255, green: 91/255, blue: 106/255))
                
                Text("Around \(source.locationName)(\(String(format:"%.1f", source.location.longitude))º, \(String(format:"%.1f", source.location.latitude))º)")
                    .font(.arial.subtitle)
                    .foregroundColor(.gray)
            }
        }
    }
    
    var textFields: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.arial.subtitle)
                .foregroundColor(.gray)
            TextField("", text: $viewModel.name)
                .padding()
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                )
                .padding(.bottom, 15)
            
            Text("Message")
                .font(.arial.subtitle)
                .foregroundColor(.gray)
            TextEditor(text: $viewModel.message)
                .padding()
                .frame(height: 145)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                )
            Text("⚠️ The text content can contain upto 50 characters")
                .font(.arial.subtitle)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    var submitButton: some View {
        Button(action: {}) {
            Text("write")
                .foregroundColor(.white)
                .font(.arial.cardtitle)
                .padding()
                .frame(width: 110)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 185/255, green: 212/255, blue: 82/255))
                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 5)
                )
        }
    }
}

struct NewDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        NewDocumentView()
    }
}
