//
//  ContentView.swift
//  CropImages
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showPicker:Bool = false
//    @State private var croppedImage: UIImage?
    @State private var croppedImage: Image?
    var body: some View {
        NavigationStack {
            VStack {
                if let croppedImage{
//                    Image(uiImage: croppedImage)
                    croppedImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300,height: 400)
                }else{
                    Text("No Image is selected")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }.cropImagePicker(show: $showPicker, croppedImage: $croppedImage)
//            EditImageView(isPresented: $showPicker, content: { imageState in
//                switch imageState{
//                case .empty:
//                    Text("wow world")
//                case .loading(_):
//                    ProgressView()
//                case .success(let image):
//                    Image(uiImage: image)
//                case .failure(_):
//                    Text("wow world")
//                }
//            })
            
            .padding()
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showPicker = true
                    }, label: {
                        Text("Button")
                    })
                }
            }.onDisappear(){
                self.croppedImage = nil
            }
            
        }
    }
}

#Preview {
    ContentView()
}
