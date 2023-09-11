//
//  LoginView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
   
    @State var email: String = ""
    @State var password: String = ""
    
    @EnvironmentObject private var appState: AppState
   
    private func login() async {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            appState.routes.append(.main)
        } catch {
            appState.errorWrapper = ErrorWrapper(error: error)
        }
    }
    
    var body: some View {
        ZStack {
            Image("bg_anya")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Anya")
                    .font(.custom("chalkduster", size: 25))
                
                LoginDetailView(placeholder: "Email", detail: $email)
                LoginDetailView(placeholder: "Password", detail: $password)
                
                Button("Log In"){
                    Task{
                        await login()
                    }
                }
                .font(.custom("chalkduster", size: 15))
                .padding(10)
                .border(Color.gray, width: 1)
                .foregroundColor(Color("darkPurple"))
                .bold()
                .tint(.black)
                
                HStack {
                    
                    Text("Don't have account yet? ")
                        .font(.custom("chalkduster", size: 15))
                        .shadow(color: .gray, radius: 10)
                        .foregroundColor(.gray)
                    
                    Button("Sign in"){
                        appState.routes.append(.signup)
                    }
                    .font(.custom("chalkduster", size: 15))
                    .padding(10)
                    .foregroundColor(Color("darkPurple"))
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState())
    }
}

struct LoginDetailView: View {
    
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
