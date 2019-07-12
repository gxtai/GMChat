//
//  SearchResultModel.swift
//  GMChat
//
//  Created by GXT on 2019/6/28.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

enum SearchType {
    case friend
    case group
    case chatHistory
    case all
}

struct SearchResultModel {
    var conversationType: RCConversationType
    var searchType: SearchType
    var targetId: String
    var name: String
    var portraitUri: String
    var otherInformation: String
    var count: Int32
    var objectName: String
    var time: Int64
    var locatedMessageSentTime: Int64
    
    init() {
        conversationType = .ConversationType_PRIVATE
        searchType = .all
        targetId = ""
        name = ""
        portraitUri = ""
        otherInformation = ""
        count = 0
        objectName = ""
        time = 0
        locatedMessageSentTime = 0
    }
}
