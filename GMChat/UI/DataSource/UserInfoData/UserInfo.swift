//
//  UserInfo.swift
//  GMChat
//
//  Created by GXT on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfo {
    
    var phoneNum: String = ""
    var userId: String = ""
    var name: String = ""
    var photo: String = ""
    var imToken: String = ""
    var createTime: String = ""
    var securityPhoneNum: String = ""
    
    static let shared = UserInfo()
    
    init() {
        
        if let userID = UserDefaults.standard.object(forKey: currentUserID) {
            
            let realm = try! Realm()
            
            let userRealm = realm.object(ofType: UserInfoRealm.self, forPrimaryKey: userID)
            phoneNum = userRealm!.phoneNum
            userId = userRealm!.userId
            name = userRealm!.name
            photo = userRealm!.photo
            imToken = userRealm!.imToken
            createTime = userRealm!.createTime
            securityPhoneNum = phoneNum.phoneNumReplaceWithStar()
            
        }
        
    }
}
