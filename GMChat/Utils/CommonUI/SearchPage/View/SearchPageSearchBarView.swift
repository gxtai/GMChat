//
//  SearchPageSearchBarView.swift
//  GMChat
//
//  Created by GXT on 2019/6/20.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol SearchPageSearchBarViewDelegate: NSObjectProtocol {
    func textFieldEditingChanged(_ textField: UITextField)
    func textFieldShouldClear(_ textField: UITextField)
}

class SearchPageSearchBarView: UIView {
    
    var cancleSearchCallback: (() -> Void)?
    weak var delegate: SearchPageSearchBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @objc func cancleBtnClicked() {
        
        if let cancleSearchCallback = cancleSearchCallback {
            cancleSearchCallback()
        }
        
    }
    
    func setupViews() {
        textField.snp_makeConstraints { (make) in
            make.bottom.equalTo(-(kNavBarHeight - 33.0) / 2.0);
            make.right.equalTo(-58);
            make.left.equalTo(12);
            make.height.equalTo(33);
        }
        
        cancleBtn.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.top.equalTo(kStatusBarHeight)
            make.width.equalTo(58)
        }
    }
    
    lazy var textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.backgroundColor = .white
        textField.font = FONT(13)
        textField.placeholder = "搜索"
        textField.tintColor = mainColor
        textField.clearButtonMode = .whileEditing
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 33))
        let searchIcon = UIImageView(image: UIImage(named: "common_search_bar_search_icon"))
        leftView.addSubview(searchIcon)
        searchIcon.snp_makeConstraints({ (make) in
            make.center.equalTo(leftView.snp_center).offset(0)
        })
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.returnKeyType = .search
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.becomeFirstResponder()
        self.addSubview(textField)
        return textField
    }()
    
    lazy var cancleBtn: UIButton = {
        let cancleBtn = UIButton(type: .custom)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(mainColor, for: .normal)
        cancleBtn.titleLabel?.font = FONT(14)
        self.addSubview(cancleBtn)
        cancleBtn.addTarget(self, action: #selector(cancleBtnClicked), for: .touchUpInside)
        return cancleBtn
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SearchPageSearchBarView: UITextFieldDelegate {
    ///
    @objc func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.textFieldEditingChanged(textField)
    }
    /// 将要开始输入
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    /// 将要结束输入
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    /// 结束输入
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    /// 将要清空输入框
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldClear(textField)
        return true
    }
    
}
