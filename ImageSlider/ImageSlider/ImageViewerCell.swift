//
//  ImageViewerCell.swift
//  ImageSlider
//
//  Created by Developer on 5/29/24.
//

import Foundation
import UIKit
import SwiftUI
struct ImageViewerCell: UIViewRepresentable{
    @State var image: UIImage
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    func makeCoordinator() -> () { }
    func makeUIView(context: Context) -> some UIView {
        let view = ImgView()
        view.image = image
        return view
    }
    
}
final class ImgView: UIView,UIScrollViewDelegate{
    var image:UIImage?{
        didSet{
            guard let image else {return}
            self.imageView.image = image
        }
    }
    private lazy var imageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "heart")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    private let scrollView = UIScrollView()
    private var scale:CGFloat = 1
    private var point: CGPoint = .zero
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 0.8
        scrollView.bouncesZoom = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("didzooming \(scale)")
        scrollView.setZoomScale(max(1,scale), animated: true)
    }
}
