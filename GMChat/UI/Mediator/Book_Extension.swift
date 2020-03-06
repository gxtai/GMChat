//
//  Book_Extension.swift
//  GMChat
//
//  Created by GXT on 2019/12/11.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
private let MediatorBookTarget = "Book"

private let MediatorGotoUserDynamicPageAction = "gotoUserDynamicPage"

public extension HMMediator {
    
    func mediator_gotoUserDynamicPage(_ params:[String: Any]?) -> UIViewController? {
        
//        MediatorOptions * options = [MediatorOptions optionsWithTargetName:MediatorLoginRegistPageTarget actionName:MediatorWechatLoginViewControllerAction];
//        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:params];
//        [dic setObject:resultBlock forKey:@"resultBlock"];
//        options.parameters = dic;
//        return [self performWithOptions:options];
        
        let options = MediatorOptions.setup(withTargetName: MediatorBookTarget, actionName: MediatorGotoUserDynamicPageAction)
        
        options?.parameters = params
        
        if let viewController = self.perform(with: options!) as? UIViewController {
            return viewController
        }
        
        return nil
        
    }
    
}
