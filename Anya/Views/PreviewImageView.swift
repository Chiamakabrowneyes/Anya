//
//  PreviewImageView.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/22/23.
//

import SwiftUI

struct PreviewImageView: View {
    let selectedImage: UIImage
    var onCancel: () -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .top) {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .font(.largeTitle)
                            .offset(y: 10)
                            .foregroundColor(.white)
                    }
                }
        }
    }
}

struct PreviewImageView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewImageView(selectedImage: UIImage(named: "bg_anya")!, onCancel: { })
    }
}
