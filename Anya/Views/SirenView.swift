//
//  SirenView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/28/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct SirenView: View {
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var model: Model
    @State private var groupDetailConfig = GroupDetailConfig()
    
    @State private var speed: Double = 50
    @State private var isEditing = false
    private func sendSiren(riskDescription: String) async throws {
       
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else { return }
        
        //get all the groups... create an iteration through the groups
        do {
            let groupDocuments = try await db.collection("heros").getDocuments().documents
            
            for groupDocument in groupDocuments {
                if let hero = Hero.fromSnapshot(snapshot: groupDocument) {
                    var sirenText: String = (currentUser.displayName ?? "Guest") +  " has sent out a siren."
                    
                    var riskText: String = "Risk Description: " + riskDescription
                    
                    var sirenMessage = ChatMessage(fromId: "hsahssacm", toId: "Chiamaka", text: sirenText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString)
                    
                    var riskMessage = ChatMessage(fromId: "hsahssacm", toId: "Chiamaka", text: riskText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString)
                    
                    do {
                        try await model.saveChatMessageToGroup(chatMessage: sirenMessage, group: hero)
                        try await model.saveChatMessageToGroup(chatMessage: riskMessage, group: hero)
                    } catch {
                        print("Error saving chat message: \(error)")
                    }
                } else {
                    print("Error converting snapshot to Hero object")
                }
            }
        } catch {
            print("Error fetching group documents: \(error)")
        }
    }
    
    var body: some View {
        
        var riskDescription: String {
                switch Int(speed) {
                case ..<20:
                    return "Very minimal risk level"
                case 20..<40:
                    return "Minimal risk level"
                case 40..<60:
                    return "Average risk level"
                case 60..<80:
                    return "Beyond average risk level"
                case 80..<90:
                    return "Dangerous risk level"
                default:
                    return "Very Dangerous risk level"
                }
            }
        
        VStack {
            Text("\(Int(speed))")
                .foregroundColor(Color("darkPurple"))
            
            Slider(
                value: $speed,
                in: 0...100,
                step: 2
            )
            {
                Text("Speed")
            } minimumValueLabel: {
                Text("0")
            } maximumValueLabel: {
                Text("100")
            } onEditingChanged: { editing in
                isEditing = editing
            }
            .frame(width: 300)
            .foregroundColor(Color("darkPurple"))
            .accentColor(Color("darkPink"))
            
            
            Text(riskDescription)
                .foregroundColor(Color("darkPurple"))
                
                
            Spacer()
                .frame(height: 50)
            
            Button("Send Siren Call") {
                Task {
                    try await sendSiren(riskDescription: riskDescription)
                }
            }.font(.custom("chalkduster", size: 15))
            .padding(10)
            .border(Color.gray, width: 1)
            .foregroundColor(Color("darkPurple"))
            .bold()
            .tint(.black)
        }
    }
}

struct SirenView_Previews: PreviewProvider {
    static var previews: some View {
        SirenView()
            .environmentObject(AppState())
            .environmentObject(Model())
    }
}
