//
//  DynamicListModel.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/16.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DynamicListModel: ModelProtocol {
    
    let id: String
    let feed_content: Int
    let like_count: Int
    let feed_comment_count: Int
    let created_at: String
    let created_at_string: String
    let has_like: Bool
    let brand: String
    let user: DynamicListUserModel
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.feed_content = json["feed_content"].intValue
        self.like_count = json["like_count"].intValue
        self.feed_comment_count = json["feed_comment_count"].intValue
        self.created_at = json["created_at"].stringValue
        self.has_like = json["has_like"].boolValue
        self.brand = json["brand"].stringValue
        self.user = DynamicListUserModel.init(json: json["user"])
        self.created_at_string = created_at
    }
    
}

struct DynamicListUserModel: ModelProtocol {
    
    let id: String
    let name: String
    let phone: String
    let photo: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.photo = json["photo"].stringValue
    }
    
}
