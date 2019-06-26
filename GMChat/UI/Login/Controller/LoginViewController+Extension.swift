//
//  LoginViewController+Extension.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
    
    func creatUI() {
        self.headerImage.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(kTopHeight - 14)
            make.size.equalTo(CGSize(width: KW(44) , height: KW(44)))
        }
        
        self.tipsLab.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.headerImage.snp.bottom).offset(20)
        }
        
        self.accountTF.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.tipsLab.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(KW(44))
        }
        
        self.passwordTF.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(self.accountTF.snp.bottom).offset(0)
            make.right.equalTo(-15)
            make.height.equalTo(KW(44))
        }
        
        self.loginBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.top.equalTo(self.passwordTF.snp.bottom).offset(12)
        }
    }
    
    
    @objc func textFieldEditingChanged(textField: UITextField) {
        if textField == self.accountTF && textField.text?.count == 11 {
            self.passwordTF.becomeFirstResponder()
        }
        
        if self.accountTF.text?.count == 11 && self.passwordTF.text?.count != 0 {
            self.loginBtn.isEnabled = true;
        } else {
            self.loginBtn.isEnabled = false;
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textString = textField.text
        let textRange = textString?.toRange(range)
        let aString = textString?.replacingCharacters(in: textRange!, with: string)
        
        if textField == self.accountTF {
            if (string == "\n") {
                return true;
            }

            if aString!.count > 11 {
                
                let index = aString!.index(aString!.startIndex, offsetBy: 11)
                
                textField.text = String(aString!.prefix(upTo: index))
                
                return false;
            }
            
        }
        
        return true
    }

}
