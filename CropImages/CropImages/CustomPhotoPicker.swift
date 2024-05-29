//
//  CustomPhotoPicker.swift
//  CropImages
//
//  Created by 김태윤 on 12/22/23.
//

import SwiftUI
import UIKit
import PhotosUI
import Photos

struct Custom: UIViewControllerRepresentable{
    let configuration: PHPickerConfiguration
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: Custom
        
        init(_ parent: Custom) {
            self.parent = parent
        }
        deinit{
            print("Coordinator 사라짐")
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            parent.isPresented = false // Set isPresented to false because picking has finished.
        }
    }
}
