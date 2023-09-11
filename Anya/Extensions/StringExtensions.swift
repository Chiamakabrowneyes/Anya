//
//  StringExtensions.swift
//  Anya
//
//  Created by chiamakabrowneyes on 7/16/23.
//

import Foundation
extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
