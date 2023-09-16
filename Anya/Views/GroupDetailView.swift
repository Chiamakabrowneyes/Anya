//
//  GroupDetailView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/4/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage


struct GroupDetailView: View {
    
    let hero: Hero
    @StateObject var viewModel: ChatViewModel
    @EnvironmentObject private var model: Model
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    @EnvironmentObject private var appState: AppState
    
    
    init(hero: Hero, viewModel: ChatViewModel) {
        self.hero = hero
        self._viewModel = StateObject(wrappedValue: ChatViewModel(hero: hero))
    }
    /*
    private func sendMessage() async throws {
        
        guard let currentUser = Auth.auth().currentUser else { return }
        var chatMessage = ChatMessage(text: groupDetailConfig.chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "": currentUser.photoURL!.absoluteString)
        
        if let selectedImage = groupDetailConfig.selectedImage {
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData()
            else { return }
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
        }
        
        try await model.saveChatMessageToGroup(chatMessage: chatMessage, group: group)
    }
     */
    private func clearFields() {
        groupDetailConfig.clearForm()
        appState.loadingState = .idle
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ChatMessageListView(viewModel: viewModel, chatMessages: model.chatMessages, hero: hero)
                    .onChange(of: model.chatMessages) { value in
                        if !model.chatMessages.isEmpty {
                            let lastChatMessage = model.chatMessages[model.chatMessages.endIndex - 1]
                            withAnimation {
                                proxy.scrollTo(lastChatMessage.id, anchor: .bottom)
                            }
                        }
                    }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("Camera") {
                groupDetailConfig.sourceType = .camera
            }
            Button("Photo Library") {
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(image: $groupDetailConfig.selectedImage, sourceType:
                            sourceType)
        })
        .overlay(alignment: .center, content: {
            if let selectedImage = groupDetailConfig.selectedImage {
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation {
                        groupDetailConfig.selectedImage = nil
                    }
                }
            }
        })
            .overlay(alignment: .bottom, content: {
                ChatMessageInputView(viewModel: viewModel, groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatTextFieldFocused) {
                    Task {
                        do {
                            appState.loadingState = .loading("Sending...")
                            viewModel.sendMessage(text: groupDetailConfig.chatText)
                            clearFields()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.padding()
            })
            .onDisappear{
                model.detachFirebaseListener()
            }
            .onAppear{
                model.listenForChatMessages(in: hero)
            }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ChatViewModel(hero: Hero(heroFullName: "Chiamaka U", heroEmail: "chiamaka@gmail.com", heroPhoneNumber: "4155703748", heroShortMessage: "Thanks for agreeing to help"))
        return GroupDetailView(hero: viewModel.hero, viewModel: viewModel)
            .environmentObject(Model())
            .environmentObject(AppState())
    }
}
