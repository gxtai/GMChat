//
//  LoginViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper
import RealmSwift

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        creatUI()
    }
    
    
    @objc func loginBtnClicked() {
        
        if self.accountTF.text?.count == 0 {
            print("请输入账号")
            return
        }
        
        if self.passwordTF.text?.count == 0 {
            print("请输入密码")
            return
        }
        
        let result = judgeUserIsExist(phoneNum: self.accountTF.text!)
        
        if !result.result {
            print("该用户不存在")
            return
        }
        
        self.login(bookListModel: result.model!)
    }
    
    /// MARK: - 登录 -
    func login(bookListModel: BookListModel) {
        showWaitWithText("正在登录，请稍后~")
        /// 模拟服务器过程
        let dic = ["userId": bookListModel.id,
                   "name": bookListModel.name,
                   "portraitUri": bookListModel.photo]
        
        Network.shared.requestDataWithTargetJSON(target: Login.token(dic), successClosure: { (json) in
            
            let code = json["code"].doubleValue
            
            if code == 200 {

                self.connectRCIM(token: json["token"].stringValue)
                
            } else {
                showFailMessage("登录失败，请稍后再试")
            }
            
            
        }) { (message) in
            showFailMessage(message)
        }
        
    }
    
    /// 链接融云服务器
    func connectRCIM(token: String) {
        RCIM.shared()?.connect(withToken: token, success: { (userId) in
            if let userId = userId {
                self.userInfo(token: token, userID: userId)
            } else {
                showFailMessage("登录状态失效，请重新登录")
            }
        }, error: { (status) in
            DispatchQueue.main.async {
                showFailMessage("登录状态失效，请重新登录\(status.rawValue)")
            }
        }, tokenIncorrect: {
            DispatchQueue.main.async {
                showFailMessage("登录状态失效，请重新登录")
                logOut()
            }
        })
    }
    
    /// 获取用户信息
    func userInfo(token: String, userID: String) {
        
        let dic = ["userId": userID]
        
        Network.shared.requestDataWithTargetJSON(target: Login.userInfo(dic), successClosure: { (json) in
            
            let code = json["code"].doubleValue
            
            if code == 200 {
                
                showSuccessMessage("登录成功")
                
                let userModel = UserInfoModel(json: json)
                
                let userRealm = UserInfoRealm()
                userRealm.phoneNum = self.accountTF.text!
                userRealm.name = userModel.userName
                userRealm.photo = userModel.userPortrait
                userRealm.userId = userID
                userRealm.imToken = token
                userRealm.createTime = userModel.createTime
                print(Realm.Configuration.defaultConfiguration.fileURL)
                /// 强制解包
                let realm = try! Realm()

                do {
                    try realm.write {
                        realm.add(userRealm, update: true)
                    }
                } catch {
                    print(error)
                }
                
                RCIM.shared()?.currentUserInfo = RCUserInfo(userId: userID, name: userModel.userName, portrait: userModel.userPortrait)
                
                UserDefaults.standard.set(userID, forKey: currentUserID)
                UserDefaults.standard.set(true, forKey: loginStatus)
                UIApplication.shared.keyWindow?.rootViewController = TabBarViewController()
                
            } else {
                showFailMessage("获取用户信息失败，请稍后再试")
            }
            
        }) { (message) in
            showFailMessage(message)
        }
        
    }
    
    @objc func eyeBtnClicked(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordTF.isSecureTextEntry = !sender.isSelected
    }

    /// MARK: - lazy -
    lazy var headerImage: UIImageView = {
        let image = UIImageView(image: UIImage(named:"login_avatar_user"))
        image.layer.cornerRadius = KW(44) / 2;
        image.layer.masksToBounds = true
        self.view.addSubview(image)
        return image
    }() // 头像
    
    lazy var tipsLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.withHex(hexString: "#000000")
        lab.font = FONT_Medium(20)
        lab.text = "欢迎使用GMChat"
        lab.sizeToFit()
        self.view.addSubview(lab)
        return lab
    }() // 提示语
    
    lazy var accountTF: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .numberPad
        self.view.addSubview(textField)
        textField.placeholder = "请输入手机号"
        textField.tintColor = UIColor.withRGB(51, 51, 51)
        textField.clearButtonMode = .whileEditing
        
        let leftContentView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: KW(44)))
        textField.leftView = leftContentView
        textField.leftViewMode = .always
        
        let leftImageView = UIImageView(image: UIImage(named: "login_phone_icon"))
        leftContentView.addSubview(leftImageView)
        leftImageView.center = leftContentView.center
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.withHex(hexString: "#e5e5e5")
        textField.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(textField:)), for: .editingChanged)
        textField.text = "13666666600"
        return textField
    }() // 账号
    
    lazy var passwordTF: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.isSecureTextEntry = true
        self.view.addSubview(textField)
        textField.placeholder = "请输入密码"
        textField.tintColor = UIColor.withRGB(51, 51, 51)
        textField.isSecureTextEntry = true

        let leftContentView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: KW(44)))
        textField.leftView = leftContentView
        textField.leftViewMode = .always
        
        let leftImageView = UIImageView(image: UIImage(named: "login_password_icon"))
        leftContentView.addSubview(leftImageView)
        leftImageView.center = leftContentView.center
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.withHex(hexString: "#e5e5e5")
        textField.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        let eyeBtn = UIButton(type: .custom)
        eyeBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        eyeBtn.setBackgroundImage(UIImage(named: "login_eye_close_icon"), for: .normal)
        eyeBtn.setBackgroundImage(UIImage(named: "login_eye_open_icon"), for: .selected)
        eyeBtn.addTarget(self, action: #selector(eyeBtnClicked(sender:)), for: .touchUpInside)
        textField.rightView = eyeBtn
        textField.rightViewMode = .always
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(textField:)), for: .editingChanged)
        textField.text = "123456"
        return textField
    }() // 密码
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton(type: .custom)
        self.view.addSubview(btn)
        btn.setTitle("登录", for: .normal)
        btn.setBackgroundImage(btnNormalImage, for: .normal)
        btn.titleLabel?.font = FONT(16)
        btn.setTitleColor(color_333333, for: .normal)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
//        btn.isEnabled = false
        return btn
    }() // 登录按钮
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
