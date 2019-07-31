//
//  UserDynamicViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/31.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class UserDynamicViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: -kStatusBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kStatusBarHeight), style: .grouped)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = color_246
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var dataArray: [SectionModel] = {
        let dataArray: [SectionModel] = []
        return dataArray
    }()
}
