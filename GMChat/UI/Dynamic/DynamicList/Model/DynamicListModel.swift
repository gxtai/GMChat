//
//  DynamicListModel.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/16.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DynamicListModel: ModelProtocol {
    
    let id: String
    let feed_content: String
    var like_count: Int
    var feed_comment_count: Int
    let created_at: Double
    let created_at_string: String
    var has_like: Bool
    let brand: String
    let user: DynamicListUserModel
    var likes: [DynamicListUserModel]
    var likes_h: CGFloat // 点赞的高度
    
    
    let content_h: CGFloat // 文本的高度
    let attributedTextString: NSMutableAttributedString
    let total_h: CGFloat // 总高度 指的动态内容的高度
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.feed_content = json["feed_content"].stringValue
        self.like_count = json["like_count"].intValue
        self.feed_comment_count = json["feed_comment_count"].intValue
        self.created_at = json["created_at"].doubleValue
        self.has_like = json["has_like"].boolValue
        self.brand = json["brand"].stringValue
        self.user = DynamicListUserModel.init(json: json["user"])
        self.created_at_string = Date.setupDateString(time: created_at)
        self.likes = json["likes"].arrayValue.map(DynamicListUserModel.init(json:))
        // 点赞的高度
        self.likes_h = DynamicListModel.likesH(likesArray: self.likes)
        /// 组装内容
        if self.feed_content.count > 0 {
            let contentString = self.feed_content
            let attributedText = NSMutableAttributedString(string: contentString)
            attributedText.yy_setFont(FONT(14), range: attributedText.yy_rangeOfAll())
            attributedText.yy_setColor(color_51, range: attributedText.yy_rangeOfAll())
            
            let highlightBorder = YYTextBorder()
            highlightBorder.fillColor = .white
            
            let regexAt = try! NSRegularExpression(pattern: "@[-_a-zA-Z0-9\u{4E00}-\u{9FA5}]+", options: [])
            
            let resultAt = regexAt.matches(in: attributedText.string, options: [], range: attributedText.yy_rangeOfAll())
            for at in resultAt {
                if at.range.location == NSNotFound && at.range.length <= 1 {
                    continue
                }
                
                if attributedText.yy_attribute(YYTextHighlightAttributeName, at: UInt(at.range.location)) == nil {
                    attributedText.yy_setColor(color_link, range: at.range)
                    // 高亮状态
                    let highlight = YYTextHighlight()
                    highlight.setBackgroundBorder(highlightBorder)
                    // 数据信息，用户稍后用户点击
                    let startIndex = attributedText.string.index(attributedText.string.startIndex, offsetBy: at.range.location + 1)
                    let endIndex = attributedText.string.index(attributedText.string.startIndex, offsetBy: at.range.location + at.range.length - 1)
                    let atName = attributedText.string[startIndex...endIndex]
                    highlight.userInfo = ["linkValue" : atName]
                    attributedText.yy_setTextHighlight(highlight, range: at.range)
                }
            }
            // 文本内容
            self.attributedTextString = attributedText
            // 文本高度
            let size = CGSize(width: SCREEN_WIDTH - 30 - DynamicListHeaderImageViewW, height: CGFloat.greatestFiniteMagnitude)
            let layout = YYTextLayout(containerSize: size, text: attributedText)
            let introHeight = layout!.textBoundingRect.height + 1
            self.content_h = introHeight
        } else {
            self.attributedTextString = NSMutableAttributedString(string: "")
            self.content_h = 0
        }
        // 总高度
        var totalHeight = DynamicListContentBaseViewH
        if feed_content.count > 0 {
            totalHeight = totalHeight + self.content_h + 5
        }
        self.total_h = totalHeight
    }
    
    static func likesH(likesArray: [DynamicListUserModel]) -> CGFloat {
        var h: CGFloat = 0
        if likesArray.count > 0 {
            /// 头像总个数
            let headerTotalCount: CGFloat = CGFloat(likesArray.count)
            /// 头像总行数
            let a = floor(headerTotalCount / likesLineHeaderCount)
            let b = headerTotalCount.truncatingRemainder(dividingBy: likesLineHeaderCount) == 0 ? 0 : 1
            let lineCount = a + CGFloat(b)
            h = CGFloat(lineCount) * dynamicListlikesCellBaseH + CGFloat((2-b) * 5)
        }
        return h
    }
}

struct DynamicListUserModel: ModelProtocol {
    
    let id: String
    let name: String
    let phone: String
    let photo: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.phone = json["phone"].stringValue
        self.photo = json["photo"].stringValue
    }
    
}

