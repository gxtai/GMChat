//
//  DynamicListViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class DynamicListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动态"
        setupNavigationItem(icon: "dynamic_publish_icon", highIcon: "dynamic_publish_icon", isLeft: false)
    }
    
    override func rightBtnClicked(sender: UIButton) {
        let publishNA = BaseNavigationViewController(rootViewController: PublishDynamicViewController())
        present(publishNA, animated: true, completion: nil)
    }

}
