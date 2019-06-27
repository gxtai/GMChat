//
//  AppDelegate.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initRoot()
        initRCIM()
        configRCIM()
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
        //设置用户信息源和群组信息源
        RCIM.shared()?.userInfoDataSource = RCIMDataSource.shared
        RCIM.shared()?.groupInfoDataSource = RCIMDataSource.shared
    }
    
    
}

