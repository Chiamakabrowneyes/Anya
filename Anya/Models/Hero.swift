//
//  Group.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/4/23.
//

import Foundation
import FirebaseFirestore

struct Hero: Codable, Identifiable {
    var documentId: String? = nil
    
    let heroFullName: String
    let heroEmail: String
    let heroPhoneNumber: String
    let heroShortMessage: String
    
    var id: String{
        documentId ?? UUID().uuidString
    }
}

extension Hero {
    func toDictionary() -> [String: Any] {
        return [ "heroFullName": heroFullName, "heroEmail": heroEmail, "heroPhoneNumber": heroPhoneNumber, "heroShortMessage": heroShortMessage]
    }
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> Hero? {
        let dictionary = snapshot.data()
        guard let heroFullName = dictionary["heroFullName"] as? String,
              let heroEmail = dictionary["heroEmail"] as? String,
              let heroPhoneNumber = dictionary["heroPhoneNumber"] as? String,
              let heroShortMessage = dictionary["heroShortMessage"] as? String
                
        else {
            return nil
        }
        return Hero(documentId: snapshot.documentID, heroFullName: heroFullName, heroEmail: heroEmail, heroPhoneNumber: heroPhoneNumber, heroShortMessage: heroShortMessage)
    }
}
