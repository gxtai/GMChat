//
//  UIBarButtonItem+Extensions.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import UIKit

class BackView: UIView {
    lazy var btn = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var navBar: UINavigationBar = UINavigationBar()
        var aView = superview
        while (aView != nil) {
            if aView?.isKind(of: UINavigationBar.self) == true {
                navBar = aView as! UINavigationBar
                break
            }
            aView = aView?.superview
        }
        
        let navItem = navBar.items?.last
        let leftItem = navItem?.leftBarButtonItem
        let rightItem = navItem?.rightBarButtonItem
        
        if let rightItem = rightItem {
            let backView = rightItem.customView as? BackView
            if let backView = backView {
                if backView.isKind(of: BackView.self) {
                    backView.btn.x = backView.width - backView.btn.width
                }
            }
        }
        
        
        if let _ = leftItem {
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIBarButtonItem {
    
    static func itemWithIcon(icon: String?, highIcon: String?, target: Any, action: Selector) -> UIBarButtonItem {
        let customView = BackView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        let tap = UITapGestureRecognizer(target: target, action: action)
        customView.addGestureRecognizer(tap)
        if let icon = icon {
            customView.btn.setBackgroundImage(UIImage(named: icon), for: .normal)
        }
        if let highIcon = highIcon {
            customView.btn.setBackgroundImage(UIImage(named: highIcon), for: .highlighted)
        }
        
        customView.btn.frame = CGRect(x: 0, y: 0, width: customView.btn.currentBackgroundImage?.size.width ?? 0, height: customView.btn.currentBackgroundImage?.size.height ?? 0)
        
        customView.btn.centerY = customView.centerY
        
        customView.btn.addTarget(target, action: action, for: .touchUpInside)
        
        customView.addSubview(customView.btn)
        
        return UIBarButtonItem(customView: customView)
    }
    
    static func itemWithTitle(title: String?, target:Any, action:Selector) -> UIBarButtonItem {
        return itemWithTitle(title: title, titleColor: UIColor.black, target: target, action: action)
    }
    
    static func itemWithTitle(title: String?, titleColor: UIColor, target:Any, action:Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = FONT(16)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(titleColor, for: .highlighted)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: title?.count ?? 0 * 18, height: 30)
        return UIBarButtonItem(customView: btn)
    }
    
    
}
