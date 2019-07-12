//
//  BookListModel.swift
//  GMChat
//
//  Created by GXT on 2019/6/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON

struct BookListModel: ModelProtocol {
    
    let id: String
    let name: String
    let photo: String
    let phone: String
    let firstCharactor: String
    
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.photo = json["photo"].stringValue
        self.phone = json["phone"].stringValue
        self.firstCharactor = self.name.firCharactor()
    }
    
}
