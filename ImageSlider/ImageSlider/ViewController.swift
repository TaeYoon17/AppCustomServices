//
//  ViewController.swift
//  ImageSlider
//
//  Created by 김태윤 on 12/27/23.
//

import UIKit

final class ViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func goImageVIewer(_ sender: Any) {
        let imageViewer = ImageViewer.UIKit()
        let nav = UINavigationController(rootViewController: imageViewer)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}
