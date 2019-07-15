//
//  PublishSelectPictureView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class PublishSelectPictureView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH / 4, height: SCREEN_WIDTH / 4)
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(PublishSelectPictureViewCell.self, forCellWithReuseIdentifier: PublishSelectPictureViewCellID)
        backgroundColor = .red
        dataSource = self
        delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9//photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublishSelectPictureViewCellID, for: indexPath)
        return cell
    }
    
    
    lazy var photoArray: [UIImage] = {
        let photoArray = [UIImage]()
        return photoArray
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
