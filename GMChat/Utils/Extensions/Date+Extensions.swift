//
//  Date+Extensions.swift
//  GMChat
//
//  Created by GXT on 2019/6/24.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    /// 获取当前 毫秒级 时间戳 - 13位
    var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    static func setupDateString<T>(time: T) -> String {
        
        let  fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "zh_Hans_CN") as Locale
        
        var createAtstr: String?
        
        if T.self == Double.self {
            let date = Date(timeIntervalSince1970: (time as! Double))
            createAtstr = fmt.string(from: date)
        } else {
            let date = fmt.date(from: time as! String)
            createAtstr = fmt.string(from: date!)
        }
        
        guard let ceateDate = fmt.date(from: createAtstr!) else{
            return ""
        }
        
        let nowDate = Date()
        let interval = nowDate.timeIntervalSince(ceateDate)
        
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(ceateDate){
            fmt.dateFormat = "昨天 HH:mm"
            return fmt.string(from: ceateDate)
        }
        
        if interval < 60 {
            return "刚刚"
        }
        
        if interval < 60*60 {
            return "\(interval/60)分钟前"
            
        }
        
        if interval < 60*60*24{
            return "\(interval/(60*60))小时前"
        }
        
        let gap = calendar.dateComponents([Calendar.Component.year], from: ceateDate, to: nowDate as Date)
        
        if gap.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            return fmt.string(from: ceateDate)
        }
        
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        return fmt.string(from: ceateDate)
        
        
    }
    
}

