//
//  ChatMessageInputView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/22/23.
//

import SwiftUI

struct ChatMessageInputView: View {
    @StateObject var viewModel: ChatViewModel
    @Binding var groupDetailConfig: GroupDetailConfig
    @FocusState var isChatTextFieldFocused: Bool
    @EnvironmentObject private var appState: AppState
    
    var onSendMessage: () -> Void
    func clearFields() {
        groupDetailConfig.clearForm()
        appState.loadingState = .idle
    }
    
    var body: some View {
        HStack {
            Button {
                groupDetailConfig.showOptions = true
            } label: {
                Image(systemName: "plus")
            }
            
            TextField("Enter text here", text: $groupDetailConfig.chatText)
                .textFieldStyle(.roundedBorder)
                .focused($isChatTextFieldFocused)
            
            Button {
                if groupDetailConfig.isValid {
                    let messageText = groupDetailConfig.chatText // Access the underlying value
                    print(messageText) // Print the message text
                    viewModel.sendMessage(text: messageText) // Call the sendMessage function with the message text
                    clearFields()
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 44))
            }.disabled(!groupDetailConfig.isValid)
        }
    }
}

