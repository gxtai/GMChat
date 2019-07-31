//
//  PublishSelectPictureViewCell.swift
//  GMChat
//
//  Created by GXT on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol PublishSelectPictureViewCellDelegate: NSObjectProtocol {
    func deleteThePicture(index: Int)
}

class PublishSelectPictureViewCell: UICollectionViewCell {
    weak var delegate: PublishSelectPictureViewCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @objc func delBtnClicked(sender: UIButton) {
        delegate?.deleteThePicture(index: sender.tag)
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
        delBtn.addTarget(self, action: #selector(delBtnClicked(sender:)), for: .touchUpInside)
        return delBtn
    }()
    
}
