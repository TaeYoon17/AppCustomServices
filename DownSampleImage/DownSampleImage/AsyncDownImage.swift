//
//  AsyncDownImage.swift
//  DownSampleImage
//
//  Created by 김태윤 on 12/14/23.
//

import SwiftUI
struct AsyncDownImage<Content,Placeholder,ErrorView>:View where Content: View,Placeholder:View,ErrorView : View{
    enum Loading{
        case empty
        case success(Image)
        case failure(Error)
    }
    @ViewBuilder let content: (Image)-> Content
    @ViewBuilder let placeholder: () -> Placeholder
    @ViewBuilder let errorView :((Error) -> ErrorView)
    private let url:URL?
    private let size: CGSize?
    @State private var loading = Loading.empty
    init(url:URL?,size: CGSize? = nil,
         @ViewBuilder content:@escaping (Image)->Content,
         @ViewBuilder placeholder:@escaping ()->Placeholder,
         @ViewBuilder failed: @escaping (Error) ->ErrorView){
        self.url = url
        self.size = size
        self.content = content
        self.placeholder = placeholder
        self.errorView = failed
    }
    var body: some View{
        Group{
            switch loading {
            case .empty:
                placeholder()
            case .success(let image):
                content(image)
            case .failure(let error):
                errorView(error)
            }
        }.task {
            do{
                guard let url else{ throw ImageServiceError.EmptyURL }
                let image = try await UIImage.fetchBy(url:url,size:size)
                self.loading = .success(Image(uiImage: image))
            }catch{
                print(error)
                self.loading = .failure(error)
            }
        }
    }
}
