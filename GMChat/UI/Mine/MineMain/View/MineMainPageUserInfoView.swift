//
//  MineMainPageUserInfoView.swift
//  GMChat
//
//  Created by GXT on 2019/6/27.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class MineMainPageUserInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func reloadData() {
        headerImageView.netImage(url: UserInfo.shared.photo, placeholderImage: headerPlaceholderImage)
        nameLab.text = UserInfo.shared.name
        phoneNumLab.text = "TEL：\(UserInfo.shared.securityPhoneNum)"
    }
    
    func setupViews() {
        self.backgroundColor = mainColor
        headerImageView.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.bottom.equalTo(-25)
            make.size.equalTo(CGSize(width: 54, height: 54))
        }
        
        nameLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(12)
            make.top.equalTo(headerImageView.snp_top).offset(3)
        }
        
        phoneNumLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(12)
            make.top.equalTo(nameLab.snp_bottom).offset(11)
        }
        
//        arrImageView.snp_makeConstraints { (make) in
//            make.right.equalTo(-15)
//            make.centerY.equalTo(headerImageView.snp_centerY).offset(0)
//        }
    }
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "common_user_header_image_place"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        self.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.font = FONT(18)
        nameLab.textColor = color_333333
        self.addSubview(nameLab)
        return nameLab
    }()
    
    lazy var phoneNumLab: UILabel = {
        let phoneNumLab = UILabel()
        phoneNumLab.font = FONT(14)
        phoneNumLab.textColor = color_333333
        self.addSubview(phoneNumLab)
        return phoneNumLab
    }()
    
    lazy var arrImageView: UIImageView = {
        let arrImageView = UIImageView(image: UIImage(named: "common_right_black_arr"))
        self.addSubview(arrImageView)
        return arrImageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
