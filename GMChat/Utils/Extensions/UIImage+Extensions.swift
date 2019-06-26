//
//  UIImage+Extensions.swift
//  DynamicSwift
//
//  Created by GXT on 2018/9/26.
//  Copyright © 2018年 GXT. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
}
