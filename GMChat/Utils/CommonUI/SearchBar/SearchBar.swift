//
//  SearchBar.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

protocol SearchBarDelegate: NSObjectProtocol {
    func clickedTheSearchBar()
}

class SearchBar: UIView {
    
    weak var delegate: SearchBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    @objc func clickedSeacrhBar() {
        delegate?.clickedTheSearchBar()
    }
    
    func setupViews() {
        
        backgroundColor = color_246
        
        let btn = UIButton(type: .custom)
        addSubview(btn)
        btn.setImage(UIImage(named: "common_search_bar_search_icon"), for: .normal)
        btn.setTitle(" 搜索", for: .normal)
        btn.titleLabel?.font = FONT(12)
        btn.setTitleColor(UIColor.withHex(hexString: "#999999"), for: .normal)
        btn.addTarget(self, action: #selector(clickedSeacrhBar), for: .touchUpInside)
        btn.backgroundColor = .white
        btn.snp_makeConstraints { (make) in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
        }
        btn.layer.cornerRadius = 4
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
