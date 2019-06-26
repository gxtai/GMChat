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
        view.backgroundColor = UIColor.withRGB(246, 246, 246)
//        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    }
    
    override func didReceiveMemoryWarning() {
        print("\(NSStringFromClass(self.classForCoder)) didReceiveMemoryWarning")
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
}
