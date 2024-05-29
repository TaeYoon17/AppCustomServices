//
//  ProfileEditImageView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI
import PhotosUI
import Combine
struct EditImageView:View{
    @StateObject var bridger: PhotoImageBridger
    @Binding var isPresented:Bool
    let content : (PhotoImageBridger.ImageState)-> any View
    init(isPresented: Binding<Bool>,content:@escaping (PhotoImageBridger.ImageState)->any View){
    스유도_라벨링_됨:do{
        self._isPresented = isPresented
        _bridger = .init(wrappedValue: PhotoImageBridger())
        self.content = content
    }
    }
    var body: some View{
        Text("Wow World")
//        CustomImagePicker(show: $isPresented, croppedImage: .ini) {
//            AnyView(content(bridger.imageState))
//        }.environmentObject(bridger).onTapGesture {
//            isPresented.toggle()
//        }
    }
}

struct Wow:View{
    var body: some View{
        VStack{
            EditImageView(isPresented: .constant(false)){ state in
                switch state{
                case .empty:
                    Text("wow world")
                case .failure( _):
                    Image(systemName: "asdf")
                case .success(let image):
                    Image(uiImage: image)
                case .loading(_):
                    ProgressView()
                @unknown default:
                    Text("wow world")
                }
            }
        }
    }
}
