//
//  SignUpView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import SwiftUI
import GameController
import FirebaseAuth

struct SignUpView: View {
    
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var repeatPassword: String = ""
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var model: Model
    
    private var FormIsValid: Bool {
        !email.isEmptyOrWhiteSpace && !fullName.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace && !repeatPassword.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await model.updateDisplayName(for: result.user, displayName: fullName)
            appState.routes.append(.login)
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
                SignUpDetailView(placeholder: "Full Name", detail: $fullName)
                SignUpDetailView(placeholder: "Email", detail: $email)
                    .textContentType(.emailAddress)
                SignUpDetailView(placeholder: "Password", detail: $password)
                    .textContentType(.password)
                SignUpDetailView(placeholder: "Repeat Password", detail: $repeatPassword)
                    .textContentType(.password)
                
                Button("Sign Up"){
                    Task {
                        await signUp()
                    }
                }.disabled(!FormIsValid)
                .font(.custom("chalkduster", size: 15))
                .padding(10)
                .border(Color.gray, width: 1)
                .foregroundColor(Color("darkPurple"))
                .bold()
                .tint(.black)
                
                HStack {
                    Text("Already Have account? ")
                        .font(.custom("chalkduster", size: 15))
                        .shadow(color: .gray, radius: 10)
                        .foregroundColor(.gray)
                    
                    Button("Log In"){
                        appState.routes.append(.login)
                    }
                    .font(.custom("chalkduster", size: 15))
                    .padding(10)
                    .foregroundColor(Color("darkPurple"))
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(Model())
            .environmentObject(AppState())
    }
}

struct SignUpDetailView: View {
    
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
