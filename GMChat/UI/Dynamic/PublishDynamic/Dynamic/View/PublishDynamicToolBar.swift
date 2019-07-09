//
//  PublishDynamicToolBar.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/8.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol PublishDynamicToolBarDelegate: NSObjectProtocol {
    func chooseThePicture()
    func chooseThePeople()
    func chooseTheEmoji()
}

class PublishDynamicToolBar: UIView {
    
    weak var delegate: PublishDynamicToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupViews()
    }
    
    @objc func keyBoardWillShow(_ notification:Notification){
        let keyBoardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        self.snp.updateConstraints { (make) in
            make.bottom.equalTo(-(keyBoardFrame.size.height) + kTabBarHeight - 44)
        }
    }
    
    @objc func keyBoardWillHide(_ notification:Notification){
        self.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func pictureBtnClicked() {
        
    }
    @objc func atBtnClicked() {
        
    }
    @objc func emojiBtnClicked() {
        self.snp.updateConstraints { (make) in
            make.bottom.equalTo(-emojiKeyboardView.height)
        }
    }
    
    func setupViews() {
        backgroundColor = UIColor.withRGB(229, 229, 229)
        pictureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        atBtn.snp.makeConstraints { (make) in
            make.left.equalTo(pictureBtn.snp_right).offset(20)
            make.centerY.equalTo(pictureBtn.snp_centerY).offset(0)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        emojiBtn.snp.makeConstraints { (make) in
            make.left.equalTo(atBtn.snp_right).offset(20)
            make.centerY.equalTo(pictureBtn.snp_centerY).offset(0)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        emojiKeyboardView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp_bottom).offset(0)
            make.size.equalTo(emojiKeyboardView.size)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var pictureBtn: UIButton = {
        let pictureBtn = UIButton(type: .custom)
        pictureBtn.setBackgroundImage(UIImage(named: "dynamic_publish_bar_choose_image_btn"), for: .normal)
        addSubview(pictureBtn)
        pictureBtn.addTarget(self, action: #selector(pictureBtnClicked), for: .touchUpInside)
        return pictureBtn
    }()
    
    lazy var atBtn: UIButton = {
        let atBtn = UIButton(type: .custom)
        atBtn.setBackgroundImage(UIImage(named: "dynamic_publish_bar_at_btn"), for: .normal)
        addSubview(atBtn)
        atBtn.addTarget(self, action: #selector(atBtnClicked), for: .touchUpInside)
        return atBtn
    }()
    
    lazy var emojiBtn: UIButton = {
        let emojiBtn = UIButton(type: .custom)
        emojiBtn.setBackgroundImage(UIImage(named: "dynamic_publish_bar_emoji_btn"), for: .normal)
        addSubview(emojiBtn)
        emojiBtn.addTarget(self, action: #selector(emojiBtnClicked), for: .touchUpInside)
        return emojiBtn
    }()
    
    lazy var emojiKeyboardView: EmojiKeyboardView = {
        let keyboardView = EmojiKeyboardView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH / 9.0 * 3.0 + 10 + 30 + kTabBarHeight - 49))
        addSubview(keyboardView)
        return keyboardView
    }()
    
}
