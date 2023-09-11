//
//  GroupListView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/4/23.
//

import SwiftUI

struct HeroListView: View {
    
    let heros: [Hero]
    @EnvironmentObject private var model: Model
    var chatMessages: [ChatMessage]
    var lastChatMessageDate: Date?
    var body: some View {
        List(heros) { hero in
            NavigationLink {
                GroupDetailView(group: hero)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(hero.heroFullName)
                    
                    Spacer()
                    
                    if !model.chatMessages.isEmpty {
                        let lastChatMessageDate = model.chatMessages[model.chatMessages.endIndex - 1].dateCreated
                    }
                    
                    VStack(alignment: .trailing){
                        Text(lastChatMessageDate ?? Date(), style: .time)
                        Image(systemName: "cube")
                    }
                }
                
                Spacer()
            }
            
        }
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView(heros: [], chatMessages: [])
            .environmentObject(Model())
    }
}
