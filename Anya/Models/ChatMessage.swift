//
//  ChatMessage.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/4/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct ChatMessage: Codable, Identifiable, Hashable{

    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
            return lhs.id == rhs.id
        }

    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    @DocumentID var messageId: String?
    let fromId: String
    let toId: String
    
    var documentId: String?
    let text: String
    let uid: String
    var dateCreated = Date()
    let displayName: String
    var profilePhotoURL: String = ""
    var attachmentPhotoURL: String = ""
    
    var hero: Hero?
    
    
    
    var id: String {
        documentId ?? UUID().uuidString
    }
    
    var displayattachmentPhotoURL: URL? {
        attachmentPhotoURL.isEmpty ? nil: URL(string: attachmentPhotoURL)
    }

    var displayProfilePhotoURL: URL? {
        profilePhotoURL.isEmpty ? nil: URL(string: profilePhotoURL)
    }
    
    var chatPartnerId: String {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
    var isFromCurrentUser: Bool {
        return fromId == Auth.auth().currentUser?.uid
    }
}

extension ChatMessage {
    func toDictionary() -> [String: Any] {
        return [
            "fromId": fromId,
            "toId": toId,
            "text": text,
            "uid": uid,
            "dateCreated": dateCreated,
            "displayName": displayName,
            "profilePhotoURL": profilePhotoURL,
            "attachmentPhotoURL": attachmentPhotoURL,
        ]
    }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> ChatMessage? {
        let dictionary = snapshot.data()
        guard let toId = dictionary["toId"] as? String,
              let fromId = dictionary["fromId"] as? String,
              let text = dictionary["text"] as? String,
              let uid = dictionary["uid"] as? String,
              let dateCreated = (dictionary["dateCreated"] as? Timestamp)?.dateValue(),
              let displayName = dictionary["displayName"] as? String,
              let profilePhotoURL = dictionary["profilePhotoURL"] as? String,
              let attachmentPhotoURL = dictionary["attachmentPhotoURL"] as? String
                
        else {
            return nil
        }
        return ChatMessage(fromId: fromId, toId: toId, documentId: snapshot.documentID, text: text, uid: uid, dateCreated: dateCreated, displayName: displayName, profilePhotoURL: profilePhotoURL, attachmentPhotoURL: attachmentPhotoURL)
    }
    
    
}
