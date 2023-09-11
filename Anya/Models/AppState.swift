//
//  AppState.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/25/23.
//

import Foundation

enum LoadingState: Hashable, Identifiable {
    case idle
    case loading(String)
    
    var id: Self {
        return self
    }
}

enum Route: Hashable {
    case main
    case login
    case signup
    case siren
}

class AppState: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var routes: [Route] = []
    @Published var errorWrapper: ErrorWrapper?
}
