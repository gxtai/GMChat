//
//  DynamicListImagesView.swift
//  GMChat
//
//  Created by GXT on 2019/7/18.
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

    var listModel: DynamicListModel? {
        didSet {
            setupViews(listModel: listModel!)
        }
    }
    
    func setupViews(listModel: DynamicListModel) {
        let imagesArray = listModel.images
        for view in subviews {
            if view.tag > (dynamicListImagesTag + imagesArray.count - 1) {
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
            
            imageView?.isHidden = false
            
            let imageModel = imagesArray[index]
            let imageString = imageModel.url
            var imagee: UIImage?
            /// 本地相册图片
            if imageString.contains("://") {
                imagee = DynamicListImageStore.shared.localImagesDic[imageString]
            } else {
                imagee = UIImage(named: imageString)
            }
            guard let image = imagee else {return}
            
            let photoImage = DynamicListImageStore.shared.listImageDic[imageModel.url]
            
            if let photoImage = photoImage {
                imageView!.image = photoImage
                // 在真实项目中，这种情况避免存在
                if imagesArray.count > 1 {
                    if photoImage.size.width > (dynamicListImagesW + 1) || photoImage.size.height > (dynamicListImagesH + 1) {
                        let sizeImage = image.byResize(to: CGSize(width: dynamicListImagesW, height: dynamicListImagesH), contentMode: .scaleAspectFill)
                        imageView!.image = sizeImage
                    }
                }
            } else {
                
                DispatchQueue.global().async {
                    
                    var sizeImage: UIImage?
                    
                    if imagesArray.count == 1 {
                        sizeImage = image.byResize(to: CGSize(width: listModel.firstImageSize.width, height: listModel.firstImageSize.height), contentMode: .scaleAspectFill)
                    } else {
                        sizeImage = image.byResize(to: CGSize(width: dynamicListImagesW, height: dynamicListImagesH), contentMode: .scaleAspectFill)
                    }
                    
                    DynamicListImageStore.shared.listImageDic[imageModel.url] = sizeImage
                    DispatchQueue.main.async {
                        imageView!.image = sizeImage
                    }
                    
                }
                
            }
            
            /// 点击图片
            imageView!.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer { [weak self] (ges) in
                self?.openPhotoBrowser(index: index, imagesArray: imagesArray)
            }
            imageView!.addGestureRecognizer(tap)
            
        }
        
    }
    
    func openPhotoBrowser(index: Int, imagesArray: [DynamicListImagesModel]) {
        // 数据源
        let dataSource = JXLocalDataSource(numberOfItems: {
            // 共有多少项
            return imagesArray.count
        }, localImage: { index -> UIImage? in
            // 每一项的图片对象
            let imageModel = imagesArray[index]
            let imageString = imageModel.url
            var imagee: UIImage?
            /// 本地相册图片
            if imageString.contains("://") {
                imagee = DynamicListImageStore.shared.localImagesDic[imageString]
            } else {
                imagee = UIImage(named: imageString)
            }
            return imagee
        })
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate()
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { [weak self] (browser, index, view) -> UIView? in
            return self?.viewWithTag(dynamicListImagesTag + index)
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: index)
    }
    
}
