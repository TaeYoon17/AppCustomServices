//
//  ImageViewer+SwiftUI.swift
//  ImageSlider
//
//  Created by Developer on 5/29/24.
//

import Foundation
import SwiftUI
extension ImageViewer{
    struct SwiftUI: View{
        @State var showNavigation = true
        @Environment(\.dismiss) var dismiss
        @State var pageIndex = 0
        @Binding var images:[UIImage]
        var body: some View{
            Group{
                TabView(selection: $pageIndex,content: {
                    ForEach(images.indices,id:\.self) { idx in
                        ImageViewerCell(image: images[idx]).ignoresSafeArea(.all)
                            .background(.black)
                            .tag(idx)
                    }
                }).tabViewStyle(.page(indexDisplayMode: .never)).ignoresSafeArea(.all)
            }.overlay(alignment: .top) {
                if showNavigation{ navigationBar }
            }
            .statusBar(hidden: !showNavigation)
            .onTapGesture { withAnimation { showNavigation.toggle() } }
            .background(.black)
        }
    }
}
extension ImageViewer.SwiftUI{
    var navigationBar: some View{
        HStack(content: {
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17,weight: .bold))
                    .imageScale(.large)
            }).padding(.leading,16.5)
            Spacer()
            ShareLink(items: images.map{Image(uiImage: $0)}) { image in
                SharePreview("\(images.count)개의 이미지", image: image)
            }
            .labelStyle(.iconOnly)
            .font(.system(size: 17,weight: .bold))
            .imageScale(.large).padding(.trailing,16.5)
        })
        .padding(.bottom,8)
        .overlay(alignment: .center, content: {
            if images.count > 0{
                Text("\(pageIndex + 1) / \(images.count)")
                    .font(.system(size: 17,weight: .bold)).foregroundStyle(.white)
            }
        })
        .background(.black.opacity(0.66)).tint(.white)
    }
}
