//
//  BookListService.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/20.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON

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
