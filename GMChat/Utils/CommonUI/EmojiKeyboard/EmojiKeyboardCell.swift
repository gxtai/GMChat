//
//  EmojiKeyboardCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/12.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

let EmojiKeyboardCellID = "EmojiKeyboardCellID"

class EmojiKeyboardCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        emojiImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: KW(20), height: KW(20)))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var emojiImage: UIImageView = {
        
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let pngPath = bundle?.path(forResource: "001@2x", ofType: "png")
        let image = UIImage(contentsOfFile: pngPath!)
        
        let emojiImage = UIImageView(image: image)
        self.contentView.addSubview(emojiImage)
        return emojiImage
    }()
}
