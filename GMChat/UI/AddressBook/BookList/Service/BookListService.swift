//
//  BookListService.swift
//  GMChat
//
//  Created by GXT on 2019/6/20.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON
/**
  模拟网络过程
 */
/// 获取好友列表
func fetchAllAddressBookList(callback: ([BookListModel]) -> Void) {
    let jsonPath = Bundle.main.path(forResource: "AddressBookList", ofType: "geojson")
    do {
        let listJson = try String(contentsOfFile: jsonPath!, encoding: .utf8)
        let mapjson = JSON(parseJSON: listJson)
        let friendsArray = mapjson["friends"]
        var allFriendsListArray = friendsArray.arrayValue.map(BookListModel.init(json:))
        /// 按照字母顺序排序
        allFriendsListArray.sort { (a, b) -> Bool in
            a.firstCharactor < b.firstCharactor
        }
        if allFriendsListArray.first?.firstCharactor == "#" {
            allFriendsListArray.append(allFriendsListArray.first!)
            allFriendsListArray.remove(at: 0)
        }
        callback(allFriendsListArray)
    } catch {
        print(error)
    }
}
/// 根据手机号获取用户信息
func fetchUserInfo(phoneNum: String, callback: ((result: Bool, model: BookListModel?)) -> Void) {
    fetchAllAddressBookList { (listArray) in
        var modelData: (Bool, BookListModel?) = (false, nil)
        for listModel in listArray {
            if listModel.phone == phoneNum {
                modelData = (true, listModel)
                break
            }
        }
        callback(modelData)
    }
}
/// 根据userId获取用户信息 BookListModel / RCUserInfo
func fetchUserInfo<T>(userId: String, type: T.Type, callback: ((result: Bool, model: T?)) -> Void) {
    fetchAllAddressBookList { (listArray) in
        
        var modelData: (Bool, T?) = (false, nil)
        
        for listModel in listArray {
            
            if listModel.id == userId {
                // 判断泛型类型
                if type == BookListModel.self {
                    modelData = (true, listModel) as! (Bool, T?)
                } else if type == RCUserInfo.self {
                    let rcUser = RCUserInfo(userId: listModel.id, name: listModel.name, portrait: listModel.photo)
                    modelData = (true, rcUser) as! (Bool, T?)
                }
                break
            }
            
        }
        callback(modelData)

    }
}


