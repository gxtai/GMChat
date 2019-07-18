//
//  SectionModel.swift
//  DynamicSwift
//
//  Created by GXT on 2019/6/6.
//  Copyright © 2019 GXT. All rights reserved.
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
    weak var delegate: NSObjectProtocol?
    
    override init() {
        super.init()
    }
    
    init(title: String?) {
        self.title = title
        super.init()
    }
}
