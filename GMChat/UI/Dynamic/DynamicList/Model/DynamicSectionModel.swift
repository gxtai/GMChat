//
//  DynamicSectionModel.swift
//  GMChat
//
//  Created by GXT on 2019/7/16.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class DynamicSectionModel: SectionModel {
    var dataModel: DynamicListModel?
    var className: String?
    var reuseIdentifier: String?
    var showDataString: String?
    var section: Int = 0
}
