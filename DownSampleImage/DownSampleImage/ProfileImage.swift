//
//  ProfileImage.swift
//  DownSampleImage
//
//  Created by 김태윤 on 12/14/23.
//

import SwiftUI
import PhotosUI
import Photos
// 구현부
struct ProfileImage: View{
    let imageState: PhotoImageBridger.ImageState
    var body: some View {
        Group{
            switch imageState {
            case .success(let image):
                image.resizable()
            case .loading:
                ProgressView()
            case .empty:
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
        }
    }

}
struct EditableProfile: View{
    // 추상부
     @StateObject var bridger:PhotoImageBridger
    init(size:CGSize? = nil){
    추상부_수행:do {
            _bridger = .init(wrappedValue: PhotoImageBridger(size: size))
        }
    }
    var body: some View{
        // 바인딩 하는 방법, viewModel 내부 Published를 $로 바인딩 하는 것이 아니라 viewModel 자체를 바인딩한다!!
        PhotosPicker(selection: $bridger.imageSelection) {
        스유도_라벨링_됨:do{
                ProfileImage(imageState: bridger.imageState)
            }
        }
    }
}
extension View{
    func frame(size:CGSize,alignment:Alignment) -> some View{
        self.frame(width: size.width,height: size.height,alignment: alignment)
    }
}
