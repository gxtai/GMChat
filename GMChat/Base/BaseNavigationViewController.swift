//
//  BaseNavigationViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barStyle = .blackTranslucent
        navigationBar.tintColor = .black
        navigationBar.barTintColor = UIColor.withRGB(255, 220, 47)
        let attributeDic = [NSAttributedString.Key.font: FONT_Medium(17),
                            NSAttributedString.Key.foregroundColor: UIColor.withRGB(0, 0, 0)]
        navigationBar.titleTextAttributes = attributeDic
    }
    
    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }

}
