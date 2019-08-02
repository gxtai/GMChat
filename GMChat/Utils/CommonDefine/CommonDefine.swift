//
//  CommonDefine.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
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
let color_888888 = UIColor.withHex(hexString: "#888888")
let color_000000 = UIColor.withHex(hexString: "#000000")
let color_b2b2b2 = UIColor.withHex(hexString: "#b2b2b2")
let color_666666 = UIColor.withHex(hexString: "#666666")
let color_ffdc2f = UIColor.withHex(hexString: "#ffdc2f")
let color_999999 = UIColor.withHex(hexString: "#999999")
let color_e5e5e5 = UIColor.withHex(hexString: "#e5e5e5")
let color_246 = UIColor.withRGB(246, 246, 246)
let color_51 = UIColor.withRGB(51, 51, 51)
let color_204 = UIColor.withRGB(204, 204, 204)
let color_link = UIColor.withRGB(71, 122, 172)
/// 通用按钮背景图片
let btnNormalImage = UIImage.from(color: UIColor.withHex(hexString: "#ffdc2f"))
let headerPlaceholderImage = UIImage(named: "common_user_header_image_place")

/// default
let loginStatus = "loginStatus" // 登录状态
let currentUserID = "currentUserID" // 当前登录的用户no

/// notice
let touchEventNotice: NSNotification.Name = NSNotification.Name(rawValue: "touchEventNotice")
let userDynamicLeaveFromTopScrollNotice: NSNotification.Name = NSNotification.Name(rawValue: "userDynamicLeaveFromTopScrollNotice")
