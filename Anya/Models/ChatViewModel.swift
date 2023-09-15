//
//  ChatViewModel.swift
//  Anya
//
//  Created by chiamakabrowneyes on 9/11/23.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var text = "blah bah"
    let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
    }
    func sendMessage() {
        ChatRoomMessage.sendMessage(text, toUser: hero)
    }
}
