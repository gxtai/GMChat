//
//  UserInfoRealm.swift
//  GMChat
//
//  Created by GXT on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfoRealm: Object {
    @objc dynamic var phoneNum = ""
    @objc dynamic var userId = ""
    @objc dynamic var name = ""
    @objc dynamic var photo = ""
    @objc dynamic var imToken = ""
    @objc dynamic var createTime = ""
    
    override static func primaryKey() -> String? {
        return "userId"
    }
}
