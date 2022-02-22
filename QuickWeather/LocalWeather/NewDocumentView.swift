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
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                HStack {
                    header
                    Spacer()
                }
                
                textFields
                    .padding(.top, 50)
                
                Spacer()
                
                submitButton
                notice
                Spacer()
            }
            .padding(.horizontal, 35)
        }
        .onAppear {
            if viewModel.isFirst {
                viewModel.showAlertRoutine(title: "Notice",
                                           message: "You can't edit or delete your message after you upload it. Keep this in mind!")
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton:
                        .default(Text(viewModel.alertTitle == "Notice" ? "Don't show again" : "Ok"),
                                 action: {
                                     viewModel.showAlert = false
                                     if viewModel.alertTitle == "Cool!" {
                                         self.showSheet = false
                                     }
                                     else if viewModel.alertTitle == "Notice" {
                                         UserDefaults.standard.set(false, forKey: "isFirst")
                                     }
                                 })
            )
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}

extension NewDocumentView {
    var background: some View {
        Color(red: 248/255, green: 248/255, blue: 248/255)
    }
    
    var notice: some View {
        Text("⚠️ Inappropriate postings like ads or hate speech, may result in restrictions on service use and deletion of postings. In severe cases, legal action can be taken.")
            .font(.arial.subtitle)
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
            Text("⚠️ Name must not exceed 20 letters")
                .font(.arial.subtitle)
                .foregroundColor(.gray.opacity(0.5))
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
            Text("⚠️ Message must not exceed 50 letters")
                .font(.arial.subtitle)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
    
    var submitButton: some View {
        Button(action: {
            viewModel.submit(source.location)
        }) {
            Group {
                if viewModel.isUploading {
                    ProgressView()
                } else {
                    Text("write")
                }
            }
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
        .disabled(viewModel.isUploading)
    }
}

struct NewDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        NewDocumentView(showSheet: .constant(true))
    }
}
