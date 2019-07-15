//
//  PublishDynamicViewController.swift
//  GMChat
//
//  Created by GXT on 2019/7/5.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class PublishDynamicViewController: BaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分享"
        setupViews()
    }
    /// 取消
    override func leftBtnClicked(sender: UIButton) {
        textView.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    /// 发布
    override func rightBtnClicked(sender: UIButton) {
        
    }
    /// 点击屏幕
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
        /// 表情
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let plistPath = bundle?.path(forResource: "infoEmotion", ofType: "plist")
        let dataArray = NSMutableArray(contentsOfFile: plistPath!)! as! [[String: String]]
        var mapper = [String: YYImage]()
        for dic in dataArray {
            let key = dic.keys.first!
            let value = dic.values.first!
            mapper[key] = emojiImage(name: value)
        }
        
        let parser = EmojiKeyboardParser()
        parser.emoticonMapper = mapper
        textView.textParser = parser
        
        return textView
    }()
    
    lazy var toolBar: PublishDynamicToolBar = {
        let toolBar = PublishDynamicToolBar()
        toolBar.delegate = self
        return toolBar
    }()
    
    lazy var emojiKeyboardView: EmojiKeyboardView = {
        let keyboardView = EmojiKeyboardView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_WIDTH / 9.0 * 3.0 + 10 + 30 + kTabBarHeight - 49))
        keyboardView.delegate = self
        view.addSubview(keyboardView)
        return keyboardView
    }()
}
/// 输入框
extension PublishDynamicViewController: YYTextViewDelegate {
    func textViewShouldBeginEditing(_ textView: YYTextView) -> Bool {
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(emojiKeyboardView.height)
        }
        return true
    }
}
/// toolbar
extension PublishDynamicViewController: PublishDynamicToolBarDelegate {
    /// 选择图片
    func chooseThePicture() {
        
    }
    /// at某人
    func chooseThePeople() {
        let vc = AtFriendsListViewController()
        vc.selectedPeopleCallback = { [weak self] (name) in
            self?.textView.replace((self?.textView.selectedTextRange)!, withText: "@\(name) ")
        }
        present(BaseNavigationViewController(rootViewController: vc), animated: true, completion: nil)
    }
    /// 选择表情
    func chooseTheEmoji() {
        textView.resignFirstResponder()
        toolBar.snp.updateConstraints { (make) in
            make.bottom.equalTo(-emojiKeyboardView.height)
        }
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(0)
        }
    }
    /// 放弃选择表情
    func abandonChooseTheEmoji() {
        textView.becomeFirstResponder()
        emojiKeyboardView.snp.updateConstraints { (make) in
            make.bottom.equalTo(emojiKeyboardView.height)
        }
    }
}
/// 选择表情
extension PublishDynamicViewController: EmojiKeyboardViewDelegate {
    func selectedEmojiWithImageTag(tag: String) {
        print(tag)
        textView.replace(textView.selectedTextRange!, withText: tag)
    }
}

