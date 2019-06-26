//
//  CommonDefine.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import UIKit

/// 屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height


/// 是否是iPhoneX、iPhoneXS
let DT_IS_IPHONEX_XS : Bool = (SCREEN_HEIGHT == 812.0) ? true : false
/// 是否是iPhoneXR、iPhoneX Max
let DT_IS_IPHONEXR_XSMax : Bool = (SCREEN_HEIGHT == 896.0) ? true : false
/// 是否是iPhoneX系列手机
let IS_IPHONEX_SET : Bool = (DT_IS_IPHONEX_XS||DT_IS_IPHONEXR_XSMax) ? true : false

/// 状态栏高度
let kStatusBarHeight : CGFloat = ((UIApplication.shared.statusBarFrame.size.height > 0) ? UIApplication.shared.statusBarFrame.size.height : (IS_IPHONEX_SET ? 44.0 : 20.0))
/// navigationbar高度
let kNavBarHeight : CGFloat = 44
/// tabbar高度
let kTabBarHeight : CGFloat = kStatusBarHeight > 20 ? 83 : 49
/// 导航栏高度
let kTopHeight : CGFloat = kStatusBarHeight + kNavBarHeight


/// APP主色调 黄色
let mainColor = UIColor.withRGB(255, 220, 47)
/// 常用color
let color_333333 = UIColor.withHex(hexString: "#333333")
let color_666666 = UIColor.withHex(hexString: "#666666")
let color_ffdc2f = UIColor.withHex(hexString: "#ffdc2f")
let color_999999 = UIColor.withHex(hexString: "#999999")
/// 通用按钮背景图片
let btnNormalImage = UIImage.from(color: UIColor.withHex(hexString: "#ffdc2f"))

/// default
let loginStatus = "loginStatus" // 登录状态
let currentUserID = "currentUserID" // 当前登录的用户no