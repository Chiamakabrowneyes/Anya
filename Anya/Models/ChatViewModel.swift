//
//  ChatViewModel.swift
//  Anya
//
//  Created by chiamakabrowneyes on 9/11/23.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var text = ""
    @Published var chatMessages = [ChatMessage]()
    let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
        observeMessages()
    }
    func observeMessages() {
        ChatRoomMessage.observeMessages(chatPartner: hero) { chatMessages in
            self.chatMessages.append(contentsOf: chatMessages)
        }
    }
    func sendMessage(text: String) {
        ChatRoomMessage.sendMessage(text, toUser: hero)
    }
}
