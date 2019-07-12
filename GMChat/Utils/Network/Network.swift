//
//  Network.swift
//  GMChat
//
//  Created by GXT on 2019/6/24.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON
import SwiftProgressHUD

///成功
typealias SuccessStringClosure = (String) -> Void
typealias SuccessJSONClosure = (JSON) -> Void
/// 失败
typealias FailClosure = (String?) -> Void
class Network {
    
    /// 共享实例
    static let shared = Network()
    private let failInfo="数据解析失败"
    
    /// 请求JSON数据
    func requestDataWithTargetJSON<T:TargetType>(target:T,successClosure:@escaping SuccessJSONClosure,failClosure: @escaping FailClosure) {
        let requestProvider = MoyaProvider<T>(requestClosure:requestTimeoutClosure(target: target))
        let _=requestProvider.request(target) { (result) -> () in
            switch result{
            case let .success(response):
                do {
                    let mapjson = try response.mapJSON()
                    let json=JSON(mapjson)
                    print("请求结果---\(target.baseURL)\(target.path)\n\(json)\n\n")
                    successClosure(json)
                    
                } catch {
                    failClosure(self.failInfo)
                }
            case let .failure(error):
                failClosure(error.errorDescription)
            }
        }
    }
    
    
    //设置一个公共请求超时时间
    private func requestTimeoutClosure<T:TargetType>(target:T) -> MoyaProvider<T>.RequestClosure{
        let requestTimeoutClosure = { (endpoint:Endpoint, done: @escaping MoyaProvider<T>.RequestResultClosure) in
            do{
                var request = try endpoint.urlRequest()
                request.timeoutInterval = 20 //设置请求超时时间
                done(.success(request))
            }catch{
                return
            }
        }
        return requestTimeoutClosure
    }
    
}


