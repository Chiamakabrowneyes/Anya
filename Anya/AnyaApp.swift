//
//  AnyaApp.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AnyaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var model = Model()
    @StateObject private var appstate = AppState()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appstate.routes) {
                
                
                ZStack{
                    if Auth.auth().currentUser != nil{
                        MainView()
                    } else {
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        MainView()
                    case .login:
                        LoginView()
                    case .signup:
                        SignUpView()
                    case .siren:
                        SirenView()
                    
                    }
                }
            }
            .overlay(alignment: .top, content: {
                switch appstate.loadingState {
                case .idle:
                    EmptyView()
                case .loading(let message):
                    LoadingView(message: message)
                }
                
            })
            .sheet(item: $appstate.errorWrapper, content: { errorWrapper in
                ErrorView(errorWrapper: errorWrapper)
            })
            .environmentObject(appstate)
            .environmentObject(model)
            
        }
    }
}
