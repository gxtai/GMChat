//
//  SessionListViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SessionListViewController: RCConversationListViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUnReadCount()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionConfig()
    }
    
    func sessionConfig() {
        /// 设置需要显示哪些类型的会话
        setDisplayConversationTypes([num(.ConversationType_PRIVATE),
                                     num(.ConversationType_APPSERVICE),
                                     num(.ConversationType_DISCUSSION),
                                     num(.ConversationType_CHATROOM),
                                     num(.ConversationType_GROUP),
                                     num(.ConversationType_APPSERVICE),
                                     num(.ConversationType_SYSTEM)])
        /// 设置需要将哪些类型的会话在会话列表中聚合显示
        setCollectionConversationType([num(.ConversationType_DISCUSSION),
                                       num(.ConversationType_GROUP)])
        conversationListTableView.tableFooterView = UIView()
        conversationListTableView.tableHeaderView = searchBar
        setConversationPortraitSize(CGSize(width: 44, height: 44))
        emptyConversationView = PlaceHolderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kTopHeight - kTabBarHeight), text: "当前还没有会话\n在通讯录中找个人聊聊吧", imageName: "session_list_empty_image")
        conversationListTableView.separatorColor = color_e5e5e5
        isShowNetworkIndicatorView = true
        showConnectingStatusOnNavigatorBar = true
    }
    
    /// lazy
    lazy var searchBar: SearchBar = {
        let searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        searchBar.delegate = self
        return searchBar
    }()
}

extension SessionListViewController {
    /// 点击聊天cell
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        // 普通模式聊天
        if conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL {
            let sessionDetailVC = SessionDetailViewController()
            sessionDetailVC.conversationType = model.conversationType
            sessionDetailVC.targetId = model.targetId
            sessionDetailVC.title = model.conversationTitle
            sessionDetailVC.conversation = model
            sessionDetailVC.unReadMessage = model.unreadMessageCount
            sessionDetailVC.enableNewComingMessageIcon = true
            sessionDetailVC.enableUnreadMessageIcon = true
            // 单聊 不显示发送方昵称
            if model.conversationType == .ConversationType_PRIVATE {
                sessionDetailVC.displayUserNameInCell = false
            }
            navigationController?.pushViewController(sessionDetailVC, animated: true)
        }
    }
    /// 点击用户头像
    override func didTapCellPortrait(_ model: RCConversationModel!) {
        // 普通模式聊天
        if model.conversationModelType == .CONVERSATION_MODEL_TYPE_NORMAL {
            let sessionDetailVC = SessionDetailViewController()
            sessionDetailVC.conversationType = model.conversationType
            sessionDetailVC.targetId = model.targetId
            sessionDetailVC.title = model.conversationTitle
            sessionDetailVC.conversation = model
            sessionDetailVC.unReadMessage = model.unreadMessageCount
            sessionDetailVC.enableNewComingMessageIcon = true
            sessionDetailVC.enableUnreadMessageIcon = true
            // 单聊 不显示发送方昵称
            if model.conversationType == .ConversationType_PRIVATE {
                sessionDetailVC.displayUserNameInCell = false
            }
            navigationController?.pushViewController(sessionDetailVC, animated: true)
        }
    }
    
    override func willDisplayConversationTableCell(_ cell: RCConversationBaseCell!, at indexPath: IndexPath!) {
        super.willDisplayConversationTableCell(cell, at: indexPath)
        let currentCell = cell as! RCConversationCell
        currentCell.conversationTitle.font = FONT(16)
        currentCell.conversationTitle.textColor = color_000000
        currentCell.messageContentLabel.font = FONT(12)
        currentCell.messageContentLabel.textColor = color_999999
        currentCell.messageCreatedTimeLabel.font = FONT(12)
        currentCell.messageCreatedTimeLabel.textColor = color_b2b2b2
        currentCell.lastSendMessageStatusView.image = nil
    }
    
    /// 接收到新的消息
    override func didReceiveMessageNotification(_ notification: Notification!) {
        super.didReceiveMessageNotification(notification)
    }
    
    /// 未读消息数量
    override func notifyUpdateUnreadMessageCount() {
        updateUnReadCount()
    }
    
    func updateUnReadCount() {
        DispatchQueue.main.async { [weak self] in
            let count = RCIMClient.shared().getUnreadCount(self?.displayConversationTypeArray)
            if count > 0 {
                self?.navigationItem.title = "消息(\(count))"
                self?.tabBarController?.tabBar.selectedItem?.badgeValue = "\(count)"
            } else {
                self?.navigationItem.title = "消息"
                self?.tabBarController?.tabBar.selectedItem?.badgeValue = nil
            }
            
        }
    }
}

/// search
extension SessionListViewController: SearchBarDelegate {
    func clickedTheSearchBar() {
        navigationController?.pushViewController(SearchPageViewController(), animated: false)
    }
}
