//
//  SignUpView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    
    var body: some View {
        ZStack {
            Image("bg_anya")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Anya")
                    .font(.custom("chalkduster", size: 25))
                
                ContentDetailView(placeholder: "Full Name", detail: $fullName)
                
                ContentDetailView(placeholder: "Email", detail: $email)
                ContentDetailView(placeholder: "Password", detail: $password)
                ContentDetailView(placeholder: "Repeat Password", detail: $repeatPassword)
               
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentDetailView: View {
    
    let placeholder: String
    let detail: Binding<String>
    
    var body: some View {
        TextField(placeholder, text: detail).textInputAutocapitalization(.never).backgroundStyle(.blue.gradient)
            .padding(10)
            .border(Color.gray, width: 1)
            .font(.custom("chalkduster", size: 15))
            .multilineTextAlignment(.center)
            .shadow(color: .gray, radius: 10)
            .frame(width: 300)
    }
}
