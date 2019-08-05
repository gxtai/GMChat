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
    
    override func presentImagePreviewController(_ model: RCMessageModel!) {
        print(model)
//        let loader = JXKingfisherLoader()
//        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
//            return 1
//        }, placeholder: { index -> UIImage? in
//            return nil
//        }) { [weak self] index -> String? in
//            return model.
//        }
//        let delegate = JXDefaultPageControlDelegate()
//        let trans = JXPhotoBrowserZoomTransitioning { [weak self] (browser, index, view) -> UIView? in
//            return self?.headerImageView
//        }
//        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
//            .show(pageIndex: 0)
    }
}
