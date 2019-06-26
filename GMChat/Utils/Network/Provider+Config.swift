//
//  Provider+Config.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/24.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    public var method: Moya.Method {
        return .post
    }
    /// baseURL
    public var baseURL: URL {
        return URL(string: apiURL)!
    }
    /// 公共的请求头
    public var headers: [String: String]? {
        
        var bodyDictionary = [String: String]()
        
        bodyDictionary["App-Key"] = RCIMKey
        
        let randNum = arc4random()
        bodyDictionary["Nonce"] = "\(randNum)"
        
        let timesTamp = Date().milliStamp
        bodyDictionary["Timestamp"] = timesTamp
        
        let signatureString = RCIMSecret + "\(randNum)" + timesTamp
        bodyDictionary["Signature"] = signatureString.sha1()
        
        return bodyDictionary
    }
    public var sampleData: Data { return Data() }
}
