//
//  ContentView.swift
//  DownSampleImage
//
//  Created by 김태윤 on 12/14/23.
//

import SwiftUI
import Photos
import PhotosUI
struct ContentView: View {
    let vm = ImageDownVM()
    @State var selectedItems: [PhotosPickerItem] = []
    let url = URL(string:"https://img.sbs.co.kr/newimg/news/20230515/201784254_1280.jpg")
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Spacer()
            EditableProfile(size: .init(width: 200, height: 200)).background(Color.red).frame(width: 200,height: 200)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

