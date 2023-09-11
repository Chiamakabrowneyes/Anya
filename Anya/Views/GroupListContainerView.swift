//
//  GroupListContainerView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/25/23.
//

import SwiftUI

struct GroupListContainerView: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject private var model: Model
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("Add New Hero"){
                    isPresented = true
                }
                .font(.custom("chalkduster", size: 15))
                .padding(10)
                .border(Color.gray, width: 1)
                .foregroundColor(Color("darkPurple"))
                .bold()
                .tint(.black)
            }
            
            HeroListView(heros: model.heros, chatMessages: model.chatMessages)
                .font(.custom("chalkduster", size: 15))
                .padding(10)
                .foregroundColor(Color("darkPurple"))
                .bold()
                .tint(.black)
            
            Spacer()
        }
        .task {
            do {
                try await model.populateGroups()
            } catch {
                print(error)
            }
        }
        .padding()
            .sheet(isPresented: $isPresented){
                AddNewHeroView()
            }
    }
}

struct GroupListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        GroupListContainerView()
            .environmentObject(Model())
    }
}
