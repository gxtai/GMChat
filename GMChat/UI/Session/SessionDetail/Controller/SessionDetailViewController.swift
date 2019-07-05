//
//  SessionDetailViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/25.
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
    
    
    func config() {
        enableUnreadMessageIcon = true
        enableNewComingMessageIcon = true
        // 单聊 不显示发送方昵称
        if conversationType == .ConversationType_PRIVATE {
            displayUserNameInCell = false
        }
    }
}

extension SessionDetailViewController {
    override func willDisplayMessageCell(_ cell: RCMessageBaseCell!, at indexPath: IndexPath!) {
    }
}
