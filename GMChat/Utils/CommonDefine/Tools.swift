//
//  Tools.swift
//  GMChat
//
//  Created by GXT on 2019/6/25.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import SwiftProgressHUD

/// 屏幕宽高比 5s的尺寸
func KW(_ width: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.width / 320 * width
}
func KH(_ height: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.height / 568 * height
}

/// Font
func FONT(_ num: CGFloat) -> UIFont {
    let font = UIFont.init(name: "PingFangSC-Regular", size: num) ?? UIFont.systemFont(ofSize: num)
    return font
}
func FONT_Medium(_ num: CGFloat) -> UIFont {
    let font = UIFont.init(name: "PingFangSC-Medium", size: num) ?? UIFont.systemFont(ofSize: num)
    return font
}
func FONT_Light(_ num: CGFloat) -> UIFont {
    let font = UIFont.init(name: "PingFangSC-Light", size: num) ?? UIFont.systemFont(ofSize: num)
    return font
}

/// 根据类名获取类
func swiftClassFromString(className: String) -> AnyClass! {
    // 工程名
    if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String? {
        // 类名
        let classStringName = appName + "." + className
        return NSClassFromString(classStringName)
    }
    return nil;
}

/// msg toast
func showSuccessMessage(_ message: String?) {
    hudHide()
    guard let message = message else { return }
    SwiftProgressHUD.showSuccess(message)
}
func showFailMessage(_ message: String?) {
    hudHide()
    guard let message = message else { return }
    SwiftProgressHUD.showFail(message)
}
func showWaitWithText(_ text: String){
    hudHide()
    SwiftProgressHUD.showWaitWithText(text)
}
func showWait(){
    SwiftProgressHUD.showWait()
}
func hudHide(){
    SwiftProgressHUD.hideAllHUD()
}

/// RCConversationType 枚举 转为 NSNumber
func num(_ value: RCConversationType) -> NSNumber {
    return NSNumber(value: value.rawValue)
}

/// 退出登录
func logOut() {
    UserDefaults.standard.set(nil, forKey: currentUserID)
    UserDefaults.standard.set(false, forKey: loginStatus)
    RCIM.shared()?.logout()
    UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
}

//func emojiImage(name: String) -> {
//    let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
//    let bundle = Bundle.init(path: bundlePath)
//    let pngPath = bundle?.path(forResource: "\(name)@2x", ofType: "png")
//    let data = NSData(contentsOfFile: pngPath)
//    let
//}
