//
//  Model.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class Model: ObservableObject {
    
    @Published var heros: [Hero] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    private func updateUserInfoForAllMessages(uid: String, updatedInfo: [AnyHashable: Any]) async throws {
        let db = Firestore.firestore()
        
        let groupDocuments = try await db.collection("heros").getDocuments().documents
        
        for groupDoc in groupDocuments{
            let messages = try await groupDoc.reference.collection("messages")
                .whereField("uid", isEqualTo: uid)
                .getDocuments().documents
            
            for message in messages {
                try await message.reference.updateData(updatedInfo)
            }
        }
    }
    
    func updateDisplayName (for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["displayname": user.displayName ?? "Guest"])
    }
    
    
    func updatePhotoURL (for user: User, photoURL: URL) async throws {
        let request = user.createProfileChangeRequest()
        request.photoURL = photoURL
        try await request.commitChanges()
        
        try await updateUserInfoForAllMessages(uid: user.uid, updatedInfo: ["profilePhotoURL": photoURL.absoluteString])
    
    }
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func listenForChatMessages(in group: Hero) {
        let db = Firestore.firestore()
        
        chatMessages.removeAll()
        
        guard let documentId  = group.documentId else {
            return
        }
        
        self.firestoreListener = db.collection("heros")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                        
                        if let chatMessage {

                            let exists = self?.chatMessages.contains(where: {cm in
                                cm.documentId == chatMessage.documentId
                            })
                            if !exists! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
            })
        
    }
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("heros")
            .getDocuments()
        
        heros = snapshot.documents.compactMap { snapshot in
            Hero.fromSnapshot(snapshot: snapshot)
        }
    }
    
    func saveChatMessageToGroup(chatMessage: ChatMessage, group: Hero) async throws {
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await db.collection("heros")
            .document(groupDocumentId)
            .collection("messages")
            .addDocument(data: chatMessage.toDictionary())
    }

    
    func saveHero(hero: Hero, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("heros")
            .addDocument(data: hero.toDictionary()){ [weak self] error in
                if error != nil {
                    completion(error)
                } else {
                    //add the group in groups array
                    if let docRef {
                        var newHero = hero
                        newHero.documentId = docRef.documentID
                        self?.heros.append(newHero)
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                }
            }
    }
}
