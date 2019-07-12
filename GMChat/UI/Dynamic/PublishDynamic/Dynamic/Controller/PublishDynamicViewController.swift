//
//  PublishDynamicViewController.swift
//  GMChat
//
//  Created by GXT on 2019/7/5.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import YYText

class PublishDynamicViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分享"
        setupViews()
    }
    
    override func leftBtnClicked(sender: UIButton) {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    override func rightBtnClicked(sender: UIButton) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(emojiKeyboardView.height)
        }
        toolBar.recover()
    }
    
    func setupViews() {
        setupNavigationItem(title: "取消", isLeft: true)
        setupNavigationItem(title: "保存", isLeft: false)
        view.addSubview(textView)
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(kTabBarHeight)
        }
        textView.becomeFirstResponder()
        
        emojiKeyboardView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(emojiKeyboardView.height)
            make.size.equalTo(emojiKeyboardView.size)
        }
    }
    
    lazy var textView: YYTextView = {
        let textView = YYTextView(frame: CGRect(x: 0, y: kTopHeight, width: SCREEN_WIDTH, height: KW(100)))
        let text = NSMutableAttributedString()
        text.yy_font = FONT(KW(14))
        text.yy_lineSpacing = 5
        text.yy_color = color_51
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.placeholderText = "说点什么吧"
        textView.placeholderFont = FONT(KW(14))
        textView.placeholderTextColor = color_204
        textView.font = FONT(KW(14))
        textView.tintColor = color_51
        textView.attributedText = text
        textView.delegate = self
        return textView
    }()
    
    lazy var toolBar: PublishDynamicToolBar = {
        let toolBar = PublishDynamicToolBar()
        toolBar.delegate = self
        return toolBar
    }()
    
    lazy var emojiKeyboardView: EmojiKeyboardView = {
        let keyboardView = EmojiKeyboardView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH / 9.0 * 3.0 + 10 + 30 + kTabBarHeight - 49))
        view.addSubview(keyboardView)
        return keyboardView
    }()
}

extension PublishDynamicViewController: YYTextViewDelegate {
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(emojiKeyboardView.height)
        }
        return true
    }
}

extension PublishDynamicViewController: PublishDynamicToolBarDelegate {
    func chooseThePicture() {
        
    }
    func chooseThePeople() {
        
    }
    func chooseTheEmoji() {
        textView.resignFirstResponder()
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(-emojiKeyboardView.height)
        }
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(0)
        }
    }
    func abandonChooseTheEmoji() {
        textView.becomeFirstResponder()
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(emojiKeyboardView.height)
        }
    }
}
