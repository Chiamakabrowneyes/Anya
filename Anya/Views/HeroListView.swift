//
//  GroupListView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/4/23.
//

import SwiftUI

struct HeroListView: View {
    
    let heros: [Hero]
    let chatMessages: [ChatMessage]
    @EnvironmentObject private var model: Model
    
    var body: some View {
        List(heros) { hero in
            NavigationLink {
                GroupDetailView(hero: hero, viewModel: ChatViewModel(hero: hero))
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(hero.heroFullName)
                    
                    Spacer()
                    
                    let lastChatMessageDate = model.chatMessages.last?.dateCreated
                    
                    VStack(alignment: .trailing) {
                        Text(lastChatMessageDate != nil ? formatDate(lastChatMessageDate!) : "")
                        Image(systemName: "cube")
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct GroupListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView(heros: [], chatMessages: [])
            .environmentObject(Model())
    }
}

