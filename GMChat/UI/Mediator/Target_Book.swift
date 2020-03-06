//
//  Target_Book.swift
//  GMChat
//
//  Created by GXT on 2019/12/11.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation

@objc class Target_Book: NSObject {
    
    @objc func action_gotoUserDynamicPage(_ params:[String: Any]?) -> UIViewController {
    
    let userDynamicVC = UserDynamicViewController()
    if let userId: String = params?["userId"] as? String {
    userDynamicVC.userId = userId
    }
    
    return userDynamicVC
    
    }
    
}
