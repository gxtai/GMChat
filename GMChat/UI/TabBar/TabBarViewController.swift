//
//  TabBarViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        
        /// 数组元素为元组类型
        let controllers: [(String, String, String, UIViewController.Type)] = [
            ("消息", "tab_session_normal", "tab_session_selected", SessionListViewController.self),
            ("通讯录", "tab_address_book_normal", "tab_address_book_selected", BookListViewController.self),
            ("动态", "tab_address_dynamic_normal", "tab_address_dynamic_selected", DynamicListViewController.self),
            ("我的", "tab_user_normal", "tab_user_selected", MineMainPageViewController.self)
        ]
        
        self.viewControllers = controllers.map({ (title, normalImage, selectedImage, controllerType) -> BaseNavigationViewController in
            
            let viewController = controllerType.init()
            
            viewController.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normalImage), selectedImage: UIImage(named: selectedImage))
            viewController.tabBarItem .setTitleTextAttributes([.font: FONT(8), .foregroundColor: UIColor.black], for: .selected)
            
            return BaseNavigationViewController(rootViewController: viewController)
        })
        
    }

}
