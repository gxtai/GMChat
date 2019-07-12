//
//  BaseViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
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
        print("\(className()) didReceiveMemoryWarning")
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("\(className()) deinit")
    }
}
