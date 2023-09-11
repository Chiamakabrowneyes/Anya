//
//  AddNewGroupView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/3/23.
//

import SwiftUI

struct AddNewHeroView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: Model
    
    @State private var heroFullName: String = ""
    @State private var heroEmail: String = ""
    @State private var heroPhoneNumber: String = ""
    @State private var heroShortMessage: String = ""
    
    private var isFormValid: Bool {
        !heroFullName.isEmptyOrWhiteSpace
        && !heroEmail.isEmptyOrWhiteSpace
        && !heroPhoneNumber.isEmptyOrWhiteSpace
    }
    private func saveHero() {
        let hero = Hero(heroFullName: heroFullName, heroEmail: heroEmail, heroPhoneNumber: heroPhoneNumber, heroShortMessage: heroShortMessage)
        model.saveHero(hero: hero) { error in
            if let error {
                print(error.localizedDescription)
            }
            dismiss()
        }
        
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                    AddHeroDetailView(placeholder: "Hero's Full Name", detail: $heroFullName)
                    AddHeroDetailView(placeholder: "Hero's Email Address", detail: $heroEmail)
                    AddHeroDetailView(placeholder: "Hero's Phone Number", detail: $heroPhoneNumber)
                    AddHeroDetailView(placeholder: "Short Message to Hero", detail: $heroShortMessage)
        }.toolbar{
            ToolbarItem(placement: .principal) {
                Text("NEW HERO").bold()
                    .font(.custom("chalkduster", size: 20))
                    .padding(10)
                    .foregroundColor(Color("darkPurple"))
                    .bold()
                    .tint(.black)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                    .font(.custom("chalkduster", size: 15))
                    .border(Color.gray, width: 1)
                    .foregroundColor(Color("darkPurple"))
                    .bold()
                    .tint(.black)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Create") {
                    saveHero()
                }.disabled(!isFormValid)
                    .font(.custom("chalkduster", size: 15))
                    .border(Color.gray, width: 1)
                    .foregroundColor(Color("darkPurple"))
                    .bold()
                    .tint(.black)
            }
        }
        }.padding()
    }
}

struct AddNewHeroView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddNewHeroView()
                .environmentObject(Model())
        }
    }
}

struct AddHeroDetailView: View {
    
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
