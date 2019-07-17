//
//  RowModel.swift
//  DynamicSwift
//
//  Created by GXT on 2019/6/6.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
/// 这里不能用结构体 因为需要转为OC的数据类型
class RowModel: NSObject {
    var title: String?
    var subTitle: String?
    var imageName: String?
    var height: CGFloat = 0
    var size: CGSize = .zero
    var selectorString: String?
    var showDataString: String?
    var className: String?
    var reuseIdentifier: String?
    var style: UITableViewCell.CellStyle = .default
    var accessoryType: UITableViewCell.AccessoryType = .none
    var selectionStyle: UITableViewCell.SelectionStyle = .default
    var indexPath: IndexPath?
    var dataModel: Any?
    
    override init() {
        super.init()
    }
    
    /// 默认的cell类型
    init(title: String?, className: String?, reuseIdentifier: String?) {
        self.title = title
        self.className = className
        self.reuseIdentifier = reuseIdentifier
        self.height = 44
        self.showDataString = "showDataWithRowModel:"
        self.accessoryType = .disclosureIndicator
        super.init()
    }
    
    /**
     类方法 前面要加 static关键字
     
     static func normalRowModel(title: String?, className: String?, reuseIdentifier: String?) -> RowModel {
     let rowModel = RowModel()
     rowModel.title = title
     rowModel.className = className
     rowModel.reuseIdentifier = reuseIdentifier
     rowModel.height = 44
     rowModel.showDataString = "showDataWithRowModel:"
     rowModel.accessoryType = .disclosureIndicator
     return rowModel
     }
     
    */
    
}
