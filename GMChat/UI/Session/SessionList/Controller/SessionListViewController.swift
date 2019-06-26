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
        if let conversationListDataSource = conversationListDataSource {
            if conversationListDataSource.count == 0 {
                PlaceHolderView.show(in: view, frame: view.frame, text: "当前还没有会话\n在通讯录中找个人聊聊吧", imageName: "session_list_empty_image")
            } else {
                PlaceHolderView.hide(from: view)
            }
        } else {
            PlaceHolderView.hide(from: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "消息"
        sessionConfig()
        print(conversationListDataSource.count)
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
    }
    
    func num(_ value: RCConversationType) -> NSNumber {
        return NSNumber(value: value.rawValue)
    }
}
