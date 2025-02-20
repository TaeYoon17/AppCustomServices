//
//  CustomImageView.swift
//  CropImages
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI
import PhotosUI
extension View{
    @ViewBuilder func frame(_ size:CGSize) -> some View{
        self.frame(width: size.width,height: size.height)
    }
    func cropImagePicker(show: Binding<Bool>, croppedImage: Binding<Image?>) -> some View{
        CustomImagePicker(show: show,croppedImage: croppedImage) {
            self
        }
    }
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle){
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
struct ImagePickerModifier: ViewModifier{
    @Binding var show: Bool
    @Binding var croppedImage: Image?
    @State var selectedImage: Image?
    @State var showCropView = false
    @State var imageSelection: PhotosPickerItem?
    init(show: Binding<Bool>,croppedImage: Binding<Image?>) {
        self._croppedImage = croppedImage
        self._show = show
    }
    func body(content: Content) -> some View {
        content
            .onDisappear(){
                selectedImage = nil
                imageSelection = nil
            }
            .photosPicker(isPresented: $show, selection: $imageSelection,matching: .images,photoLibrary: .shared())
            .onChange(of: imageSelection, perform: { newValue in
                guard let newValue else {return}
                let progress = newValue.loadTransferable(type: Image.self) {result in
                    Task {
                        guard imageSelection == self.imageSelection else {
                            print("Failed to get the selected item.")
                            return
                        }
                        switch result {
                        case .success(let profileImage?):
//                            let uiimage = UIImage.fetchBy(data: profileImage,size: .init(width: 360, height: 360))
//                            let uiimage =
                            
                            self.selectedImage = profileImage
                            
                        case .success(nil):
                            //                            imageState = .empty
                            self.selectedImage = nil
                        case .failure(let error):
                            self.selectedImage = nil
                        }
                    }
                }
                //                imageState = .loading(progress)
            })
            .onChange(of: selectedImage){ newValue in
                guard let newValue else {return}
                Task{@MainActor in
                    try await Task.sleep(nanoseconds:1000)
                    showCropView = true
                }
            }
    }
}
struct CustomImagePicker<Content:View>: View{
    var content: Content
    @Binding var show: Bool
    @Binding var croppedImage: Image?
    @State var selectedImage: Image?
    @State var selectedCropType:Crop = .circle
    @State var showCropView = false
    @State var imageSelection: PhotosPickerItem?
    init(show: Binding<Bool>,croppedImage: Binding<Image?>,content: @escaping ()->Content) {
        self.content = content()
        self._croppedImage = croppedImage
        self._show = show
    }
    @State private var photosItem: PhotosPickerItem?
    var body: some View{
        content
            .onDisappear(){
                selectedImage = nil
                imageSelection = nil
            }
            .photosPicker(isPresented: $show, selection: $imageSelection,matching: .images,photoLibrary: .shared())
            .onChange(of: imageSelection, perform: { newValue in
                guard let newValue else {return}
                
                let progress = newValue.loadTransferable(type: Image.self) {result in
                    Task {
                        guard imageSelection == self.imageSelection else {
                            print("Failed to get the selected item.")
                            return
                        }
                        switch result {
                        case .success(let profileImage?):
//                            let uiimage = UIImage.fetchBy(data: profileImage,size: .init(width: 360, height: 360))
//                            let uiimage =
                            
                            self.selectedImage = profileImage
                            
                        case .success(nil):
                            //                            imageState = .empty
                            self.selectedImage = nil
                        case .failure(let error):
                            self.selectedImage = nil
                        }
                    }
                }
                //                imageState = .loading(progress)
            })
            .onChange(of: selectedImage){ newValue in
                guard let newValue else {return}
                Task{@MainActor in
                    try await Task.sleep(nanoseconds:1000)
                    showCropView = true
                }
            }
//            .fullScreenCover(isPresented: $showCropView, onDismiss: {
//                selectedImage = nil
//            }, content: {
//                CropView(image: $selectedImage){ croppedImage,status in
//                    //                        print(croppedImage,status)
//                    if let croppedImage{
//                        self.croppedImage = croppedImage
//                    }
//                    //                        vm.isCroppedError = status
//                    
//                }
//                
//            })
    }
}

struct CropView: View{
    
    @Binding var image:Image?
    var onCrop: (Image?,Bool) -> ()
    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false  // 인터렉션 중인지 알려줌
    @State private var maskHidden = false
    let cropSize = CGSize(width: 360, height: 360)
    var body: some View{
        NavigationStack{
            imageView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(.black)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button{
                            // 이미지 렌더러를 통해서 이미지 가져오기
                            let renderer = ImageRenderer(content: imageView().clipShape(Circle()))
                            renderer.proposedSize = .init(cropSize)
                            if let image = renderer.uiImage{
                                onCrop(Image(uiImage: image),false)
                            }else{
                                onCrop(nil,true)
                            }
                            dismiss()
                        }label: {
                            Image(systemName: "checkmark")
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Button{
                            onCrop(nil,false)
                            dismiss()
                        }label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .onAppear(){
                    Task{@MainActor in
                        try await Task.sleep(for: .seconds(0.33))
                        withAnimation { maskHidden = true }
                    }
                }
        }
    }
}
extension CropView{
    @ViewBuilder func imageView()->some View{
        
        ZStack(alignment: .center){
            GeometryReader{ proxy in
                let size = proxy.size
                if let image{
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(content: {
                            GeometryReader(content: { proxy in
                                let rect = proxy.frame(in: .named("CROPVIEW"))
                                Color.clear.onChange(of: isInteracting) { newValue in
                                    /// true -> 드래그
                                    /// false -> 드래그 멈춤
                                    /// 이거 사용해서 최소 x,y / 최대 x,y를 알 수 있다.
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        if rect.minX > 0{
                                            offset.width = (offset.width - rect.minX)
                                        }
                                        if rect.minY > 0{
                                            offset.height = offset.height - rect.minY
                                        }
                                        if rect.maxX < size.width{
                                            offset.width = rect.minX - offset.width
                                        }
                                        if rect.maxY < size.height{
                                            offset.height = rect.minY - offset.height
                                        }
                                    }
                                    
                                    if !newValue{
                                        lastStoredOffset = offset
                                    }
                                }
                            })
                        })
                        .frame(size)
                }
            }
            .scaleEffect(scale)
            .offset(offset)
            .coordinateSpace(name:"CROPVIEW")
            .frame(cropSize)
            if maskHidden{
                ZStack(alignment: .center){
                    Rectangle()
                        .animation(.easeInOut(duration: 0.2), value: isInteracting)
                        .foregroundStyle(Color.black.opacity(isInteracting ? 0.5 : 1))
                    Circle()
                        .frame(cropSize)
                        .blendMode(.destinationOut)
                }
                .compositingGroup()
            }
        }.gesture(
            DragGesture().updating($isInteracting, body: { val, state, transact in
                state = true
            }).onChanged({ value in
                let translation = value.translation
                offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
            })
        )
        //MARK: -- Magnify Gesture
        .gesture(MagnificationGesture()
            .updating($isInteracting, body: { val, state, transct in
                state = true
            }).onChanged({ value in
                let updatedScale = value.magnitude + lastScale
                scale = (updatedScale < 1 ? 1 : updatedScale)
            }).onEnded({ value in
                withAnimation {
                    if scale < 1{
                        scale = 1
                        lastScale = 0
                    }else{
                        lastScale = scale - 1
                    }
                }
            }))
        .ignoresSafeArea()
    }
}
//#Preview(body: {
//    NavigationStack{
//        CropView(image: UIImage(named: "picture_demo")) { image, val in
//            
//        }
//    }
//})
