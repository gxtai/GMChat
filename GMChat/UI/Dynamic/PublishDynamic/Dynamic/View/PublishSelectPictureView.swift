//
//  PublishSelectPictureView.swift
//  GMChat
//
//  Created by GXT on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
private let maxCount = 9
private let lineCount = 4
class PublishSelectPictureView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {

    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: SCREEN_WIDTH / CGFloat(lineCount), height: SCREEN_WIDTH / CGFloat(lineCount))
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(PublishSelectPictureViewCell.self, forCellWithReuseIdentifier: PublishSelectPictureViewCellID)
        backgroundColor = .white
        dataSource = self
        delegate = self
        let row = Int(maxCount / lineCount) + (Int(maxCount % lineCount) == 0 ? 0 : 1)
        self.height = SCREEN_WIDTH / CGFloat(lineCount) * CGFloat(row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == photoArray.count {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.delegate = self
            findController().present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoArray.count >= maxCount {
            return photoArray.count
        }
        return photoArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublishSelectPictureViewCellID, for: indexPath) as! PublishSelectPictureViewCell
        cell.delegate = self
        if indexPath.row == photoArray.count {
            cell.coverImageView.image = UIImage(named: "dynamic_publish_add_picture_default")
            cell.delBtn.isHidden = true
        } else {
            let imageKey = photoArray[indexPath.row]["url"] as! String
            let image = DynamicListImageStore.shared.localImagesDic[imageKey]
            cell.coverImageView.image = image
            cell.delBtn.isHidden = false
            cell.delBtn.tag = indexPath.row
        }
        return cell
    }
    
    
    lazy var photoArray: [[String: Any]] = {
        let photoArray = [[String: Any]]()
        return photoArray
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PublishSelectPictureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PublishSelectPictureViewCellDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        findController()?.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        findController()?.dismiss(animated: true, completion: nil)
        
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        let urlString = "\(info[UIImagePickerController.InfoKey.referenceURL] ?? 0)" + "\(Date().milliStamp)"
        let imageDic: [String: Any] = ["url": urlString,
                        "width": image.size.width,
                        "height": image.size.height
                        ]
        DynamicListImageStore.shared.localImagesDic[urlString] = image
        photoArray.append(imageDic)
        reloadData()
    }
    func deleteThePicture(index: Int) {
        photoArray.remove(at: index)
        reloadData()
    }
}
