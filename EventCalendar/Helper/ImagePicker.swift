//
//  ImagePicker.swift
//  EventCalendar
//
//  Created by YA on 2023/9/7.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    // MARK: - Property Wrapper
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var m_eventContent: EventContent
    @ObservedObject var m_event: Event
    @Binding var m_dateCurrent: Date
    
    // MARK: - Property
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // MARK: - Property
        
        var parent: ImagePicker
        
        // MARK: - Initialize
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // MARK: - Method
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                do {
                    if parent.m_eventContent.id != nil {
                        print("已經有")
                        let fetchRequest = EventContent.fetchRequest()
                        fetchRequest.predicate = NSPredicate(format: "id == %@", parent.m_eventContent.id! as CVarArg)
                        
                        if let eventContentToUpdate = try? parent.viewContext.fetch(fetchRequest).first {
                            eventContentToUpdate.image = image.jpegData(compressionQuality: 1.0)!
                            print(eventContentToUpdate)
                        }
                    } else {
                        print("+")
                        let eventContent = EventContent(context: parent.viewContext)
                        eventContent.id = UUID()
                        eventContent.image = image.jpegData(compressionQuality: 1.0)!
                        eventContent.date = parent.m_dateCurrent
                        eventContent.event = parent.m_event
                        print(eventContent)
                    }
                    
                    try parent.viewContext.save()
                } catch {
                    let nsError = error as NSError
                    
                    fatalError("編輯錯誤\(nsError), \(nsError.userInfo)")
                }
            }
            
            parent.dismiss()
        }
        
    }
    
}
