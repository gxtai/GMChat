//
//  EmojiKeyboardView.swift
//  GMChat
//
//  Created by GXT on 2019/7/9.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol EmojiKeyboardViewDelegate: NSObjectProtocol {
    func selectedEmojiWithImageTag(tag: String)
}

class EmojiKeyboardView: UIView {

    weak var delegate: EmojiKeyboardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .white
        addSubview(collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: SCREEN_WIDTH / 8.0, height: SCREEN_WIDTH / 8.0)
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiKeyboardCell.self, forCellWithReuseIdentifier: NSStringFromClass(EmojiKeyboardCell.self))
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var dataArray: [[String: String]] = {
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let plistPath = bundle?.path(forResource: "infoEmotion", ofType: "plist")
        let dataArray = NSMutableArray(contentsOfFile: plistPath!)! as! [[String: String]]
        return dataArray
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmojiKeyboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(EmojiKeyboardCell.self), for: indexPath) as! EmojiKeyboardCell
        let dic: [String: String] = dataArray[indexPath.row]
        let value = dic.values.first!
        
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let pngPath = bundle?.path(forResource: "\(value)@2x", ofType: "png")
        let image = UIImage(contentsOfFile: pngPath!)
        
        cell.emojiImage.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dic: [String: String] = dataArray[indexPath.row]
        let key = dic.keys.first!
        delegate?.selectedEmojiWithImageTag(tag: key)
    }
    
}
