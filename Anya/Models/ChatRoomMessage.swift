//
//  ChatRoomMessage.swift
//  Anya
//
//  Created by chiamakabrowneyes on 9/11/23.
//

import Foundation
import Firebase


struct ChatRoomMessage {
    let groupDetailConfig = GroupDetailConfig()
    
    static let messagesCollection = Firestore.firestore().collection("messages")
    
    static func sendMessage(_ text: String, toUser hero: Hero) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = hero.id
        let currentUserRef = messagesCollection.document(currentUid).collection(chatPartnerId).document()
        let chatPartnerRef = messagesCollection.document(chatPartnerId).collection(currentUid)
        
        let messageId = currentUserRef.documentID
        let chatRoomMessage = ChatRoomMessage()
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let message = ChatMessage(messageId: messageId,
                                  fromId: currentUid,
                                  toId: chatPartnerId,
                                  text: text,
                                  uid: currentUid,
                                  dateCreated: Date(),
                                  displayName: currentUser.displayName ?? "Guest",
                                  profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString
        )
        
        guard let messageData = try? Firestore.Encoder().encode(message) else { return }
        currentUserRef.setData(messageData)
        chatPartnerRef.document(messageId).setData(messageData)
    }
    
    static func observeMessages(chatPartner: Hero, completion: @escaping([ChatMessage]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let chatPartnerId = chatPartner.id
        let query = messagesCollection
            .document(currentUid)
            .collection(chatPartnerId)
            .order(by: "timeCreated", descending: false)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            var chatMessages = changes.compactMap({ try? $0.document.data(as: ChatMessage.self)})
            for (index, message) in chatMessages.enumerated() where message.fromId != currentUid {
                chatMessages[index].hero = chatPartner
            }
            completion(chatMessages)
        }
    }
}
