//
//  ChatMessageListView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/5/23.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    @StateObject var viewModel: ChatViewModel
    let hero: Hero
    
    init(viewModel: ChatViewModel, chatMessages: [ChatMessage], hero: Hero) {
        self._viewModel = StateObject(wrappedValue: ChatViewModel(hero: hero))
        self.hero = hero
    }
    
    private func isChatMessageFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        return currentUser.uid == chatMessage.uid
    }
    
    var body: some View {
        ScrollView{
            VStack {
                
                ForEach(viewModel.chatMessages, id: \.id) { chatMessage in
                    VStack {
                        if isChatMessageFromCurrentUser(chatMessage) {
                            HStack {
                                Spacer()
                                ChatMessageView(chatMessage: chatMessage, direction: .right, color: .blue)
                            }
                        } else {
                            HStack {
                                ChatMessageView(chatMessage: chatMessage, direction: .left, color: .gray)
                            }
                        }
                        Spacer().frame(height: 20)
                            .id(chatMessage.id)
                        
                    }.listRowSeparator(.hidden)
                }
            }
        }.padding([.bottom], 60)
    }
}
