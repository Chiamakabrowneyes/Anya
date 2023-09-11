//
//  ImagePicker.swift
//  Anya
//
//  Created by chiamakabrowneyes on 8/15/23.
//

import SwiftUI
import Foundation

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    typealias Coordinator = ImagePickerCoordinator
    typealias UIViewControllerType = UIImagePickerController
    @Binding var image: UIImage?
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker : ImagePicker
        
        init(_ picker: ImagePicker) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  {
                self.picker.image = uiImage
            }
            self.picker.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.picker.dismiss()
        }
    }
}
