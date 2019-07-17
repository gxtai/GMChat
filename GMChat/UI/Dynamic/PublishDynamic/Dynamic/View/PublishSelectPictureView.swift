//
//  PublishSelectPictureView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/15.
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
        let row = Int(maxCount / lineCount) + Int(maxCount % lineCount) == 0 ? 0 : 1
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
            cell.coverImageView.image = photoArray[indexPath.row]
            cell.delBtn.isHidden = false
            cell.delBtn.tag = indexPath.row
        }
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

extension PublishSelectPictureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PublishSelectPictureViewCellDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        findController()?.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        findController()?.dismiss(animated: true, completion: nil)
        guard let image: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        photoArray.append(image)
        reloadData()
    }
    func deleteThePicture(index: Int) {
        photoArray.remove(at: index)
        reloadData()
    }
}
