//
//  UIView+Extensions.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// X
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.origin.x = newVal
            self.frame = frame
        }
    }
    /// Y
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.origin.y = newVal
            self.frame = frame
        }
    }
    /// 宽
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size.width = newVal
            self.frame = frame
        }
    }
    /// 高
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size.height = newVal
            self.frame = frame
        }
    }
    /// size 宽高
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(newVal) {
            var frame: CGRect = self.frame
            frame.size = newVal
            self.frame = frame
        }
    }
    /// 中心X
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newVal) {
            var center: CGPoint = self.center
            center.x = newVal
            self.center = center
        }
    }
    /// 中心Y
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newVal) {
            var center: CGPoint = self.center
            center.y = newVal
            self.center = center
        }
        
    }
    
}
