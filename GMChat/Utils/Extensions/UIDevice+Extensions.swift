//
//  UIDevice+Extensions.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/29.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

extension UIDevice {
    /// 获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            case "iPod5,1":
                return "iPod Touch 5"
            case "iPod7,1":
                return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2","iPhone3,3":
                return "iPhone 4"
            case "iPhone4,1":
                return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":
                return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":
                return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":
                return "iPhone 5s"
            case "iPhone7,2":
                return "iPhone 6"
            case "iPhone7,1":
                return "iPhone 6 Plus"
            case "iPhone8,1":
                return "iPhone 6s"
            case "iPhone8,2":
                return "iPhone 6s Plus"
            case "iPhone9,1":
                return "iPhone 7"//"iPhone 7 (CDMA)"
            case "iPhone9,3":
                return "iPhone 7"//"iPhone 7 (GSM)"
            case "iPhone9,2":
                return "iPhone 7 Plus"//"iPhone 7 Plus (CDMA)"
            case "iPhone9,4":
                return "iPhone 7 Plus"//"iPhone 7 Plus (GSM)"
            case "iPhone10,1", "iPhone10,4":
                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":
                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":
                return "iPhone X"
            case "iPhone11,2":
                return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":
                return "iPhone XS Max"
            case "iPhone11,8":
                return "iPhone XR"
            
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":
                return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":
                return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":
                return "iPad Air"
            case "iPad5,3", "iPad5,4":
                return "iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":
                return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":
                return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":
                return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":
                return "iPad Mini 4"
            case "iPad6,7", "iPad6,8":
                return "iPad Pro"
            case "AppleTV5,3":
                return "Apple TV"
            case "i386", "x86_64":
                return "Simulator"
            default:
                return identifier
        }
    }
}
