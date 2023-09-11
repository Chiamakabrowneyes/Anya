//
//  ImageExtensions.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/14/23.
//

import Foundation
import SwiftUI

extension Image {
    
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        return self.resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}
