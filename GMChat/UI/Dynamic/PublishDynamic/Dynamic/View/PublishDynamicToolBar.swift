//
//  PublishDynamicToolBar.swift
//  GMChat
//
//  Created by GXT on 2019/7/8.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol PublishDynamicToolBarDelegate: NSObjectProtocol {
    func chooseThePicture()
    func chooseThePeople()
    func chooseTheEmoji()
    func abandonChooseTheEmoji()
}

class PublishDynamicToolBar: UIView {
    
    weak var delegate: PublishDynamicToolBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupViews()
    }
    /// 键盘将要出现
    @objc func keyBoardWillShow(_ notification:Notification){
        let keyBoardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        if emojiBtn.isSelected {
            emojiBtn.isSelected = false
        }
        snp.updateConstraints { (make) in
            make.bottom.equalTo(-(keyBoardFrame.size.height) + kTabBarHeight - 44)
        }
    }
    /// 键盘将要消息
    @objc func keyBoardWillHide(_ notification:Notification){
        snp.updateConstraints { (make) in
            make.bottom.equalToSuperview()
        }
    }
    /// 选择图片
    @objc func pictureBtnClicked() {
        
    }
    /// 选择@
    @objc func atBtnClicked() {
        
    }
    /// 选择表情
    @objc func emojiBtnClicked(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            delegate?.abandonChooseTheEmoji()
        } else {
            sender.isSelected = true
            delegate?.chooseTheEmoji()
        }
    }
    /// 恢复 失去焦点
    func recover() {
        snp.updateConstraints { (make) in
            make.bottom.equalTo(0)
        }
        emojiBtn.isSelected = false
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
        emojiBtn.setBackgroundImage(UIImage(named: "dynamic_publish_bar_keyboard_btn"), for: .selected)
        addSubview(emojiBtn)
        emojiBtn.addTarget(self, action: #selector(emojiBtnClicked(sender:)), for: .touchUpInside)
        return emojiBtn
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(className()) deinit")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        if view == nil {
            for subView in subviews {
                let p = subView.convert(point, from: self)
                if subView.bounds.contains(p) {
                    view = subView
                }
            }
        }
        return view
    }
}

extension PublishDynamicToolBar {
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
    }
}
