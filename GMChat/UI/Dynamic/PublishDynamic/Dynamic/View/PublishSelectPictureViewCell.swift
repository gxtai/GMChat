//
//  PublishSelectPictureViewCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
let PublishSelectPictureViewCellID = "PublishSelectPictureViewCellID"
class PublishSelectPictureViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        coverImageView.snp.makeConstraints { (make) in
            make.left.top.equalTo(7)
            make.bottom.right.equalTo(-7)
        }
        
        delBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(coverImageView.snp_right).offset(0)
            make.centerY.equalTo(coverImageView.snp_top).offset(0)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView(image: UIImage(named: "dynamic_publish_add_picture_default"))
        coverImageView.contentMode = UIView.ContentMode.scaleAspectFill
        coverImageView.clipsToBounds = true
        self.contentView.addSubview(coverImageView)
        return coverImageView
    }()
    
    lazy var delBtn: UIButton = {
        let delBtn = UIButton(type: .custom)
        delBtn.setImage(UIImage(named: "dynamic_publish_delegate_picture_default"), for: .normal)
        delBtn.setImage(UIImage(named: "dynamic_publish_delegate_picture_press"), for: .highlighted)
        self.contentView.addSubview(delBtn)
        return delBtn
    }()
    
}
