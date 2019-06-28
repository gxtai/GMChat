//
//  RCIMDataSource.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/27.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

class RCIMDataSource: NSObject, RCIMUserInfoDataSource {
    static let shared = RCIMDataSource()
    /*!
     获取用户信息
     
     @param userId      用户ID
     @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
     
     @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
     在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
     */
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        print("getUserInfoWithUserId ----- \(String(describing: userId))")
        let user = RCUserInfo()
        if userId == nil || userId.count == 0  {
            user.userId = userId
            user.portraitUri = ""
            user.name = ""
            completion(user)
            return
        }
        // 请求用户信息
        fetchUserInfo(userId: userId, type: RCUserInfo.self) { (result) in
            if result.result == false { return }
            guard let user = result.model else { return }
            if userId == RCIM.shared()?.currentUserInfo.userId {
                RCIM.shared()?.refreshUserInfoCache(user, withUserId: user.userId)
            }
            completion(user)
        }
        return
    }
}

extension RCIMDataSource: RCIMGroupInfoDataSource {
    /*!
     获取群组信息
     
     @param groupId     群组ID
     @param completion  获取群组信息完成之后需要执行的Block [groupInfo:该群组ID对应的群组信息]
     
     @discussion SDK通过此方法获取群组信息并显示，请在completion的block中返回该群组ID对应的群组信息。
     在您设置了群组信息提供者之后，SDK在需要显示群组信息的时候，会调用此方法，向您请求群组信息用于显示。
     */
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        
    }
}

extension RCIMDataSource: RCIMGroupUserInfoDataSource {
    /*!
     获取用户在群组中的群名片信息
     
     @param userId          用户ID
     @param groupId         群组ID
     @param completion      获取群名片信息完成之后需要执行的Block [userInfo:该用户ID在群组中对应的群名片信息]
     
     @discussion 如果您使用了群名片功能，SDK需要通过您实现的群名片信息提供者，获取用户在群组中的名片信息并显示。
     */
    func getUserInfo(withUserId userId: String!, inGroup groupId: String!, completion: ((RCUserInfo?) -> Void)!) {
        completion(nil)
    }
}

extension RCIMDataSource: RCIMGroupMemberDataSource {
    /*!
     获取当前群组成员列表（需要实现用户信息提供者 RCIMUserInfoDataSource）
     
     @param groupId     群ID
     @param resultBlock 获取成功之后需要执行的Block [userIdList:群成员ID列表]
     
     @discussion SDK通过此方法群组中的成员列表，请在resultBlock中返回该群组ID对应的群成员ID列表。
     在您设置了群组成员列表提供者之后，SDK在需要获取群组成员列表的时候，会调用此方法，向您请求群组成员用于显示。
     */
    func getAllMembers(ofGroup groupId: String!, result resultBlock: (([String]?) -> Void)!) {
        
    }
}
