//
//  EmojiKeyboardView.swift
//  GMChat
//
//  Created by GXT on 2019/7/9.
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
        addSubview(collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.itemSize = CGSize(width: SCREEN_WIDTH / 7.0, height: SCREEN_WIDTH / 7.0)
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EmojiKeyboardCell.self, forCellWithReuseIdentifier: EmojiKeyboardCellID)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = self.dataArray.count / 27
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = mainColor
        return pageControl
    }()
    
    lazy var dataArray: NSMutableArray = {
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let plistPath = bundle?.path(forResource: "infoEmotion", ofType: "plist")
        let dataArray = NSMutableArray(contentsOfFile: plistPath!)!
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
        let cell: EmojiKeyboardCell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiKeyboardCellID, for: indexPath) as! EmojiKeyboardCell
//        let dic = dataArray[indexPath.row]
//        let value = dic.v
        
        return cell
    }
    
    
}
