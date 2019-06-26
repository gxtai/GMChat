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
    /// 融云
    func initRCIM() {
        RCIM.shared()?.initWithAppKey("p5tvi9dspe844")
        
        if UserDefaults.standard.bool(forKey: loginStatus) {
            
            RCIM.shared()?.connect(withToken: UserInfo.shared.imToken, success: { (userId) in
                print("当前登录的用户id：\(String(describing: userId))")
            }, error: { (status) in
                showFailMessage("登录异常\(status)")
            }, tokenIncorrect: {
                showFailMessage("登录状态失效，请重新登录")
                UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
            })
            
        }
        
    }
}

