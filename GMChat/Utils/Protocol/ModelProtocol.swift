//
//  ModelProtocol.swift
//  GMChat
//
//  Created by GXT on 2019/6/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import SwiftyJSON

public protocol ModelProtocol {
    
    /// 通过`JSON`创建对象
    ///
    /// - Parameter json: json对象
    init(json: JSON)
}
