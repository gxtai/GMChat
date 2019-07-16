//
//  DynamicListService.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/16.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 获取动态就列表
func fetchDynamicList(callback: ([DynamicListModel]) -> Void) {
    let jsonPath = Bundle.main.path(forResource: "DynamicList", ofType: "geojson")
    do {
        let listJson = try String(contentsOfFile: jsonPath!, encoding: .utf8)
        let mapjson = JSON(parseJSON: listJson)
        let listArray = mapjson["list"]
        let listModelArray = listArray.arrayValue.map(DynamicListModel.init(json:))
        callback(listModelArray)
    } catch {
        print(error)
    }
}
