//
//  UIImageView+Extensions.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/27.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

extension UIImageView {
    func netImage(url: String, placeholderImage: UIImage?) {
        self.kf.setImage(with: URL(string: url), placeholder: placeholderImage, options: nil, progressBlock: nil, completionHandler: nil)
    }
}
