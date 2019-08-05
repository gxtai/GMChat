//
//  SessionDetailViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SessionDetailViewController: RCConversationViewController {
    
    var conversation: RCConversationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(targetId ?? "-")
        config()
    }
    
    override func rightBtnClicked(sender: UIButton) {
        let userDynamicVC = UserDynamicViewController()
        userDynamicVC.userId = targetId
        navigationController?.pushViewController(userDynamicVC, animated: true)
    }
    
    func config() {
        enableUnreadMessageIcon = true
        enableNewComingMessageIcon = true
        // 单聊 不显示发送方昵称
        if conversationType == .ConversationType_PRIVATE {
            displayUserNameInCell = false
        }
        setupNavigationItem(icon: "session_detail_user_info_icon", highIcon: "session_detail_user_info_icon", isLeft: false)
    }
}

extension SessionDetailViewController {
    
    override func willDisplayMessageCell(_ cell: RCMessageBaseCell!, at indexPath: IndexPath!) {
    }
    
    /// 点击用户头像
    override func didTapCellPortrait(_ userId: String!) {
        /// 个人主页
        let userDynamicVC = UserDynamicViewController()
        userDynamicVC.userId = userId
        navigationController?.pushViewController(userDynamicVC, animated: true)
    }
    
    /// 查看图片 点击图片
    override func presentImagePreviewController(_ model: RCMessageModel!) {
        
        guard let messageContent = model.content else { return }
        if !messageContent.isKind(of: RCImageMessage.self) { return }
        
        var cellArray: [RCImageMessageCell] = [RCImageMessageCell]()
        var imageArray: [String] = [String]()
        
        var row: NSInteger = 0
        
        for i in 0..<conversationDataRepository!.count {
            
            let rcMessageModel: RCMessageModel = conversationDataRepository[i] as! RCMessageModel
            /// 图片和cell
            if rcMessageModel.content.isKind(of: RCImageMessage.self) {
                let imageModel: RCImageMessage = rcMessageModel.content as! RCImageMessage
                let cell = self.conversationMessageCollectionView.cellForItem(at: IndexPath(item: i, section: 0)) as! RCImageMessageCell
                cellArray.append(cell)
                imageArray.append(imageModel.imageUrl)
            }
            /// 当前点击的cell
            if rcMessageModel.messageId == model.messageId {
                row = imageArray.count - 1
            }
            
        }
        /// 弹出图片浏览器
        let loader = JXKingfisherLoader()
        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return imageArray.count
        }, placeholder: { index -> UIImage? in
            let cell = cellArray[index]
            return cell.pictureView.image
        }) { index -> String? in
            return imageArray[index]
        }
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            let cell = cellArray[index]
            return cell.pictureView
        }
        let delegate = JXDefaultPageControlDelegate()
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: row)
        /// 长按手势  保存图片
        delegate.longPressedCallback = { browser, index, image, gesture in
            print("长按手势  保存图片")
        }
            
    }
    
    
}
