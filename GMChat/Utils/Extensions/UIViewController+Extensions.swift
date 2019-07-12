//
//  UIViewController+Extensions.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func leftBtnClicked(sender: UIButton) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func rightBtnClicked(sender: UIButton) {
        
    }
    
    func setupNavigationItem(icon: String?, highIcon: String?, isLeft: Bool) {
        
        if isLeft {
            let item = UIBarButtonItem.itemWithIcon(icon: icon, highIcon: highIcon, target: self, action: #selector(leftBtnClicked))
            navigationItem.leftBarButtonItem = item
        } else {
            let item = UIBarButtonItem.itemWithIcon(icon: icon, highIcon: highIcon, target: self, action: #selector(rightBtnClicked))
            navigationItem.rightBarButtonItem = item
        }
    }
    
    func setupNavigationItem(title: String?, isLeft: Bool) {
        setupNavigationItem(title: title, titleColor: UIColor.black, isLeft: isLeft)
    }
    
    func setupNavigationItem(title: String?, titleColor: UIColor, isLeft: Bool) {
        if isLeft {
            let item = UIBarButtonItem.itemWithTitle(title: title, titleColor: titleColor, target: self, action: #selector(leftBtnClicked))
            navigationItem.leftBarButtonItem = item
        } else {
            let item = UIBarButtonItem.itemWithTitle(title: title, titleColor: titleColor, target: self, action: #selector(rightBtnClicked))
            navigationItem.rightBarButtonItem = item
        }
    }
    
}
