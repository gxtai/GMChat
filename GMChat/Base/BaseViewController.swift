//
//  BaseViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color_246
//        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    override func didReceiveMemoryWarning() {
        print("\(self.className()) didReceiveMemoryWarning")
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\(self.className()) deinit")
    }
}
