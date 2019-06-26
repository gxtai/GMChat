//
//  UserInfoModel.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserInfoModel: ModelProtocol {
    
    let code: String
    let userName: String
    let userPortrait: String
    let createTime: String
    
    
    init(json: JSON) {
        self.code = json["code"].stringValue
        self.userName = json["userName"].stringValue
        self.userPortrait = json["userPortrait"].stringValue
        self.createTime = json["createTime"].stringValue
    }
    
}
