//
//  EmojiKeyboardParser.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import YYText

class EmojiKeyboardParser: YYTextSimpleEmoticonParser {
    var regex: NSRegularExpression?
    
    override init() {
        
        let pattern = "@[-_a-zA-Z0-9\u{4E00}-\u{9FA5}]+"
        regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        super.init()
    }
    
    override func parseText(_ text: NSMutableAttributedString?, selectedRange: NSRangePointer?) -> Bool {
        super.parseText(text, selectedRange: selectedRange)
        var changed = false
        guard let text = text else { return changed }
        text.yy_color = color_51
        regex?.enumerateMatches(in: text.string, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: text.yy_rangeOfAll(), using: { (result, flags, stop) in
            if result == nil { return }
            let range = result?.range
            if range?.location == NSNotFound || range!.length < 1 { return }
            text.yy_setColor(color_link, range: range!)
            changed = true
        })
        return changed
    }
}
