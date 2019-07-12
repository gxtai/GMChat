//
//  AppDelegate.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initRoot()
        initRCIM()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

extension AppDelegate {
    /// root
    func initRoot() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if UserDefaults.standard.bool(forKey: loginStatus) {
            window?.rootViewController = TabBarViewController()
        } else {
            window?.rootViewController = LoginViewController()
        }
        
    }
    /// 融云初始化和登录
    func initRCIM() {
        RCIM.shared()?.initWithAppKey("p5tvi9dspe844")
        configRCIM()
        if UserDefaults.standard.bool(forKey: loginStatus) {
            
            RCIM.shared()?.currentUserInfo = RCUserInfo(userId: UserInfo.shared.userId, name: UserInfo.shared.name, portrait: UserInfo.shared.photo)
            
            RCIM.shared()?.connect(withToken: UserInfo.shared.imToken, success: { (userId) in
                print("当前登录的用户id：\(String(describing: userId))")
            }, error: { (status) in
                DispatchQueue.main.async {
                    showFailMessage("登录状态失效，请重新登录\(status.rawValue)")
                    logOut()
                }
            }, tokenIncorrect: {
                DispatchQueue.main.async {
                    showFailMessage("登录状态失效，请重新登录")
                    logOut()
                }
            })
        }
    }
    
}

extension AppDelegate {
    /// 设置融云
    func configRCIM() {
        // 设置语音消息采样率为 16KHZ
        RCIMClient.shared().sampleRate = RCSampleRate._Rate_16000
        //设置会话列表头像和会话页面头像
//        RCIM.shared()?.connectionStatusDelegate = self
        RCIM.shared().globalConversationPortraitSize = CGSize(width: 46, height: 46)
        //    [RCIM sharedRCIM].portraitImageViewCornerRadius = 10;
        //开启用户信息和群组信息的持久化
        RCIM.shared().enablePersistentUserInfoCache = true
        //设置用户信息源和群组信息源
        RCIM.shared().userInfoDataSource = RCIMDataSource.shared
        RCIM.shared().groupInfoDataSource = RCIMDataSource.shared
        //设置名片消息功能中联系人信息源和群组信息源
//        [RCContactCardKit shareInstance].contactsDataSource = RCIMDataSource.shared
//        [RCContactCardKit shareInstance].groupDataSource = RCIMDataSource.shared
        
        //设置群组内用户信息源。如果不使用群名片功能，可以不设置
        //  [RCIM sharedRCIM].groupUserInfoDataSource = RCDDataSource;
        //  [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        //设置接收消息代理
//        RCIM.shared()?.receiveMessageDelegate = self;
        //开启输入状态监听
        RCIM.shared().enableTypingStatus = true
        //开启发送已读回执
        RCIM.shared().enabledReadReceiptConversationTypeList = [num(.ConversationType_PRIVATE),
                                                                 num(.ConversationType_DISCUSSION),
                                                                 num(.ConversationType_GROUP)];
        
        //开启多端未读状态同步
        RCIM.shared().enableSyncReadStatus = true
        
        //设置显示未注册的消息
        //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
        RCIM.shared().showUnkownMessage = true
        RCIM.shared().showUnkownMessageNotificaiton = true
        //群成员数据源
        RCIM.shared().groupMemberDataSource = RCIMDataSource.shared
        //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
        RCIM.shared().enableMessageMentioned = true
        //开启消息撤回功能
        RCIM.shared().enableMessageRecall = true
        //选择媒体资源时，包含视频文件
        RCIM.shared().isMediaSelectorContainVideo = true
        //设置Log级别，开发阶段打印详细log
        RCIMClient.shared().logLevel = .log_Level_Info
        RCIMClient.shared().setReconnectKickEnable(true)
    }
    
    
}

