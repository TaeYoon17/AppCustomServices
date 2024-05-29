//
//  ViewController.swift
//  ImageCropper
//
//  Created by 김태윤 on 12/22/23.
//

import UIKit
import Photos
import PhotosUI
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func presenter(_ sender: UIButton) {
        let picker = PHPickerViewController(configuration: .init(photoLibrary: .shared()))
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
}

extension ViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.dismiss(animated: true)
    }
}
