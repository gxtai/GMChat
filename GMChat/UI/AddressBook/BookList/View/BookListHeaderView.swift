//
//  BookListHeaderView.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/18.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

let BookListHeaderViewID = "BookListHeaderViewID"


class BookListHeaderView: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        title = nil
        titleColor = UIColor.withHex(hexString: "#999999")
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    var title: String? {
        didSet {
            titleLab.text = title
        }
    }
    var titleColor: UIColor? {
        didSet {
            titleLab.textColor = titleColor
        }
    }
    
    func setupViews() {
        contentView.backgroundColor = UIColor.withRGB(246, 246, 246)
        titleLab.snp_makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.withRGB(246, 246, 246)
        contentView.addSubview(lineView)
        lineView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = FONT(12)
        titleLab.textColor = UIColor.withHex(hexString: "#999999")
        self.contentView.addSubview(titleLab)
        return titleLab
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
