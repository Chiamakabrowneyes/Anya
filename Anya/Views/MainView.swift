//
//  MainView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/25/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            SirenView()
                .tabItem {
                    Label ("Siren", systemImage: "cube")
                }
            GroupListContainerView()
                .tabItem {
                    Label ("Chats", systemImage: "message.fill")
                }
            SettingsView()
                .tabItem {
                    Label ("Settings", systemImage: "gear")
                }
           
            //add the third view for sirens
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
