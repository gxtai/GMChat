//
//  UserDynamicNavigationBarView.swift
//  GMChat
//
//  Created by GXT on 2019/8/2.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class UserDynamicNavigationBarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var listModel: BookListModel? {
        didSet {
            guard let listModel = listModel else { return }
            viewShow(model: listModel)
        }
    }
    
    func viewShow(model: BookListModel) {
        nameLab.text = model.name
    }
    
    func setupViews() {
        clipsToBounds = true
        
        bgImageView.snp_makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(UserDynamicInfoViewH)
        }
        
        effectImageView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backBtn.snp_makeConstraints { (make) in
            make.top.equalTo(kStatusBarHeight)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        nameLab.snp_makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp_centerY).offset(0)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "common_back_white"), for: .normal)
        self.addSubview(backBtn)
        return backBtn
    }()

    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        self.addSubview(bgImageView)
        return bgImageView
    }()
    
    lazy var effectImageView: UIImageView = {
        let effectImageView = UIImageView(image: UIImage(named: "dynamic_user_page_effect_image"))
        bgImageView.addSubview(effectImageView)
        return effectImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = .white
        nameLab.font = FONT(18)
        self.addSubview(nameLab)
        return nameLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
