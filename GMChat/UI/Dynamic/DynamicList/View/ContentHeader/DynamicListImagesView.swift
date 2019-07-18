//
//  DynamicListImagesView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/18.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
/// 图片总宽度
let dynamicListImagesTotalW: CGFloat = SCREEN_WIDTH - 30 - DynamicListHeaderImageViewW
/// 图片间距
let dynamicListImagesDis:CGFloat = 5
/// 图片宽
let dynamicListImagesW: CGFloat = (dynamicListImagesTotalW - 10) / 3
/// 图片高
let dynamicListImagesH: CGFloat = dynamicListImagesW

let dynamicListImagesTag = 2000

class DynamicListImagesView: UIView {

    var imagesArray: [DynamicListImagesModel]? {
        didSet {
            setupViews(imagesArray: imagesArray!)
        }
    }
    
    func setupViews(imagesArray: [DynamicListImagesModel]) {
        
        for view in subviews {
            if view.tag > (dynamicListImagesTag + imagesArray.count) {
                view.isHidden = true
            }
        }
        
        for index in 0..<imagesArray.count {
            
            let line = floor(CGFloat(index) / 3) // 行
            let row = CGFloat(index).truncatingRemainder(dividingBy: 3) // 列
            
            var imageView = viewWithTag(dynamicListImagesTag + index) as? UIImageView
            
            if imageView == nil {
                imageView = UIImageView()
                imageView!.tag = dynamicListImagesTag + index
                addSubview(imageView!)
                imageView!.snp_makeConstraints { (make) in
                    make.left.equalTo((dynamicListImagesW + dynamicListImagesDis) * row)
                    make.top.equalTo((dynamicListImagesH + dynamicListImagesDis) * line)
                }
            }
            
            let imageModel = imagesArray[index]
            let imageString = imageModel.url
            let imagee = UIImage(named: imageString)
            guard let image = imagee else {return}
            
            let photoImage = imageDic[imageModel.url]
            
            if let photoImage = photoImage {
                imageView!.image = photoImage
            } else {
                DispatchQueue.global().async { [weak self] in
                    let sizeImage = image.byResize(to: CGSize(width: dynamicListImagesW, height: dynamicListImagesH))
                    self?.imageDic[imageModel.url] = sizeImage
                    DispatchQueue.main.async {
                        imageView!.image = sizeImage
                    }
                }
            }
            
            
        }
    }
    /// 缓存裁剪后的图片
    lazy var imageDic: [String: UIImage] = {
        let imageDic = [String: UIImage]()
        return imageDic
    }()
    
}
