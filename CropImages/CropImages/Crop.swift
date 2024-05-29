//
//  Crop.swift
//  CropImages
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI

enum Crop: Equatable{
    case circle
    case rectangle
    case square
    case custom(CGSize)
    
    var name:String{
        switch self{
        case .circle: "Circle"
        case .custom(let size): "Custom \(Int(size.width))X\(Int(size.height))"
        case .rectangle:"Rectangle"
        case .square: "Square"
        }
    }
    
    var size: CGSize{
        switch self{
        case .circle: CGSize(width: 360, height: 360)
        case .rectangle: CGSize(width: 360, height: 360)
        case .square: CGSize(width: 360, height: 360)
        case .custom(let size): size
        }
    }
}
