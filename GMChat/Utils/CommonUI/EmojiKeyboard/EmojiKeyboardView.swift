//
//  EmojiKeyboardView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/9.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class EmojiKeyboardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
