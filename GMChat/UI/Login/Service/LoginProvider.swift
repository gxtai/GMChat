//
//  LoginProvider.swift
//  GMChat
//
//  Created by GXT on 2019/6/24.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import Moya

let LoginProvider = MoyaProvider<Login>()

public enum Login {
    case token(Dictionary<String,Any>) //获取token
    case userInfo(Dictionary<String,Any>) //获取用户信息
}

extension Login: TargetType {
    
    public var path: String {
        switch self {
        case .token(_):
            return "user/getToken.json"
        case .userInfo(_):
            return "user/info.json"
        }
        
    }
    
    public var task: Task {
        switch self {
            
        case .token(let params):
            return .requestParameters(parameters: params ,
                                      encoding: URLEncoding.default)
        case .userInfo(let params):
        return .requestParameters(parameters: params ,
                                  encoding: URLEncoding.default)
            
        }
    }
    
    public var validate: Bool {
        return false
    }
    
    
}
