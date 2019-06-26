//
//  SectionModel.swift
//  DynamicSwift
//
//  Created by 花动传媒 on 2019/6/6.
//  Copyright © 2019 花动传媒. All rights reserved.
//

import UIKit

class SectionModel: NSObject {
    var title: String?
    var subTitle: String?
    var imageName: String?
    var headerHeight: CGFloat = 0.01
    var footerHeigth: CGFloat = 0.01
    var headerSize: CGSize = .zero
    var footerSize: CGSize = .zero
    var mutableCells: [RowModel] = []
    
    override init() {
        super.init()
    }
    
    init(title: String) {
        self.title = title
        super.init()
    }
}
