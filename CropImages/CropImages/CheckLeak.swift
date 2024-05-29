//
//  CheckLeak.swift
//  CropImages
//
//  Created by 김태윤 on 12/22/23.
//

import SwiftUI
import PhotosUI
struct CheckLeak: View {
    enum Wow:Identifiable{
        var id:String{
            UUID().uuidString
        }
        case one
        case two
    }
    @State private var open = false
    @State private var wow:Wow? = nil
    @State private var image:Image?
    @State private var show: Bool = false
    @State private var pickeItem: PhotosPickerItem?
    var body: some View{
        NavigationStack{
            VStack{

                Button{
//                    open.toggle()
                    show.toggle()
                    //            print("leak check")
                }label: {
                    Text("Leak Check")
                }
                .sheet(isPresented: $show, content: {
                    let configuration = PHPickerConfiguration(photoLibrary: .shared())
                    Custom(configuration: configuration, isPresented: $show)
                })
//                .photosPicker(isPresented: $show, selection: $pickeItem)
//                PhotosPicker(selection: $pickeItem, matching: .images, preferredItemEncoding: .automatic) {
//                    Text("Not modifier" )
//                }
//                .sheet(isPresented: $open) {
//                    Text("Hello world")
//                }
                //            Group{
                //                Button{
                //                    wow = .one
                //                }label: {
                //                    Text("One")
                //                }
                //                Button{
                //                    wow = .two
                //                }label: {
                //                    Text("Tow")
                //                }
                //            }.sheet(item: $wow) { wow in
                //                switch wow{
                //                case .one: LazyView(ContentView())
                //                case .two: Text("Tow")
                //                }
                //            }
            }
        }
    }
}

#Preview {
    CheckLeak()
}
struct LazyView<V:View>: View{
    let view: ()->V
    init(_ view:@autoclosure @escaping ()->V){
        self.view = view
    }
    var body: some View{
        view()
    }
}
