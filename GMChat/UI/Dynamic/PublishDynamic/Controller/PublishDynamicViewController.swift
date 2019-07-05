//
//  PublishDynamicViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/5.
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
        dismiss(animated: true, completion: nil)
    }
    
    override func rightBtnClicked(sender: UIButton) {
        
    }
    
    func setupViews() {
        setupNavigationItem(title: "取消", isLeft: true)
        setupNavigationItem(title: "保存", isLeft: false)
        self.textView.delegate = self
    }
    
    let textView: YYTextView = {
        let textView = YYTextView()
        let text = NSMutableAttributedString()
        text.yy_font = FONT(14)
        text.yy_lineSpacing = 5
        text.yy_color = color_51
        textView.backgroundColor = .white
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.placeholderText = "说点什么吧"
        textView.placeholderFont = FONT(14)
        textView.placeholderTextColor = color_204
        textView.font = FONT(14)
        textView.tintColor = color_51
        textView.attributedText = text
        return textView
    }()
    
}

extension PublishDynamicViewController: YYTextViewDelegate {

}
