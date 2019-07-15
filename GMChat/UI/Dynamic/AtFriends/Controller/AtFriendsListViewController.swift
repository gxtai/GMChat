//
//  AtFriendsListViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/15.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class AtFriendsListViewController: BookListViewController {
    var selectedPeopleCallback: ((String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    func config() {
        setupNavigationItem(title: "取消", isLeft: true)
        setupNavigationItem(icon: nil, highIcon: nil, isLeft: false)
        tableView.tableHeaderView = nil
        tableView.frame = CGRect(x: 0, y: kTopHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kTopHeight)
        dataArray.removeFirst()
        tableView.reloadData()
    }
    
    override func leftBtnClicked(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func clickedTheCell(_ rowModel: RowModel) {
        let listModel: BookListModel = rowModel.dataModel as! BookListModel
        if let selectedPeopleCallback = selectedPeopleCallback {
            selectedPeopleCallback(listModel.name)
        }
        dismiss(animated: true, completion: nil)
    }
}
