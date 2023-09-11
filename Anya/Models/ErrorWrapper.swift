//
//  ErrorWrapper.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/22/23.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}
