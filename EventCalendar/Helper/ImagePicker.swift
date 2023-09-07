//
//  ImagePicker.swift
//  EventCalendar
//
//  Created by YA on 2023/9/7.
//

import SwiftUI

//struct ImagePicker: UIViewControllerRepresentable {
//    
//    @Environment(\.presentationMode) private var presentationMode
//    @Binding var image: UIImage?
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(imagePicker: self)
//    }
//    
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        
//        return picker
//    }
//    
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        
//        private let imagePicker: ImagePicker
//        
//        init(imagePicker: ImagePicker) {
//            self.imagePicker = imagePicker
//        }
//        
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                imagePicker.image = image
//            }
//            
//            imagePicker.presentationMode.wrappedValue.dismiss()
//        }
//        
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            imagePicker.presentationMode.wrappedValue.dismiss()
//        }
//        
//    }
//    
//}
//
///*
//
//     func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//         // 更新視圖控制器
//     }
//
//     class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//         private let parent: ImagePicker
//
//         init(_ parent: ImagePicker) {
//             self.parent = parent
//         }
//
//         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//             if let uiImage = info[.originalImage] as? UIImage {
//                 parent.image = uiImage
//             }
//             parent.presentationMode.wrappedValue.dismiss()
//         }
//
//         func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//             parent.presentationMode.wrappedValue.dismiss()
//         }
//     }
// }
//
// */
