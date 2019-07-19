//
//  DynamicPushCommentView.swift
//  GMChat
//
//  Created by GXT on 2019/7/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import AudioToolbox

protocol DynamicPushCommentViewDelegate: NSObjectProtocol {
    func pushTheComment(comment: String)
}

class DynamicPushCommentView: UIView {

    var delegate: DynamicPushCommentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupViews()
    }
    
    @objc func pushBtnClicked() {
        AudioServicesPlaySystemSound(1519)
        delegate?.pushTheComment(comment: textView.text)
        textView.text = ""
        dismiss()
    }
    
    func show() {
        textView.becomeFirstResponder()
    }
    func dismiss() {
        textView.resignFirstResponder()
    }
    
    /// 键盘将要出现
    @objc func keyBoardWillShow(_ notification:Notification){
        if !textView.isFirstResponder {
            return
        }
        let keyBoardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        snp.updateConstraints { (make) in
            make.bottom.equalTo(-(keyBoardFrame.size.height))
        }
    }
    /// 键盘将要消失
    @objc func keyBoardWillHide(_ notification:Notification){
        snp.updateConstraints { (make) in
            make.bottom.equalTo(self.height)
        }
    }
    
    func setupViews() {
        backgroundColor = .white
        
        let topLine = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1))
        topLine.backgroundColor = color_e5e5e5
        addSubview(topLine)
        
        textView.snp_makeConstraints { (make) in
            make.left.top.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(74)
        }
        
        pushBtn.snp_makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(5)
            make.size.equalTo(CGSize(width: 60, height: 30))
            make.right.equalTo(-12)
        }
    }
    
    lazy var textView: YYTextView = {
        let textView = YYTextView()
        textView.backgroundColor = UIColor.white
        textView.placeholderText = "发表评论"
        textView.placeholderFont = FONT(12)
        textView.placeholderTextColor = color_204
        textView.font = FONT(14)
        textView.tintColor = color_51
        textView.delegate = self
        textView.layer.borderColor = color_e5e5e5.cgColor
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 9, left: 6, bottom: 0, right: 0)
        self.addSubview(textView)
        return textView
    }()
    
    lazy var pushBtn: UIButton = {
        let pushBtn = UIButton(type: .custom)
        pushBtn.setTitle("发表", for: .normal)
        pushBtn.setTitleColor(color_333333, for: .normal)
        pushBtn.titleLabel?.font = FONT(14)
        pushBtn.layer.cornerRadius = 3
        pushBtn.setBackgroundImage(UIImage(color: mainColor), for: .normal)
        pushBtn.isEnabled = false
        self.addSubview(pushBtn)
        pushBtn.addTarget(self, action: #selector(pushBtnClicked), for: .touchUpInside)
        return pushBtn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("\(className()) deinit")
    }
}

extension DynamicPushCommentView: YYTextViewDelegate {
    func textViewDidChange(_ textView: YYTextView) {
        pushBtn.isEnabled = textView.text.count > 0 ? true : false
    }
    
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count == 0 {
            if text == " " || text == "\n" {
                return false
            }
        }
        return true
    }
    
}
