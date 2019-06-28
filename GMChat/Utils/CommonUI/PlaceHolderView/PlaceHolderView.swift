//
//  PlaceHolderView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class PlaceHolderView: UIView {

    var placeHolderText: String?
    var imageName: String?
    
    
    public class func show(in superView: UIView, frame: CGRect, text: String?, imageName: String?) {
        let view = PlaceHolderView(frame: frame, text: text, imageName: imageName)
        hide(from: superView)
        superView.addSubview(view)
    }
    
    public class func hide(from superView: UIView) {
        for view in superView.subviews {
            if view.isKind(of: PlaceHolderView.self) {
                view.removeFromSuperview()
                break
            }
        }
    }
    
    init(frame: CGRect, text: String?, imageName: String?) {
        self.placeHolderText = text
        self.imageName = imageName
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp_bottom).offset(17)
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: self.imageName ?? "common_no_data_image"))
        addSubview(imageView)
        return imageView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.text = self.placeHolderText ?? "暂无数据"
        titleLab.font = FONT(14)
        titleLab.textAlignment = .center
        titleLab.numberOfLines = 0
        titleLab.textColor = color_333333
        addSubview(titleLab)
        return titleLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("PlaceHolderView dealloc")
    }
}
