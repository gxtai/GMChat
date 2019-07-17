//
//  MineMainPageViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class MineMainPageViewController: BaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        infoView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的"
        setupViews()
        initTableViewData()
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
        tableView.tableHeaderView = self.infoView
        return tableView
    }()
    
    lazy var dataArray: [SectionModel] = {
        let dataArray: [SectionModel] = []
        return dataArray
    }()
    
    lazy var infoView: MineMainPageUserInfoView = {
        let infoView = MineMainPageUserInfoView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 104 + kStatusBarHeight))
        return infoView
    }()

}

/// cell action
extension MineMainPageViewController {
    /// 我的主页
    @objc func gotoUserPage() {
        
    }
    /// 设置
    @objc func gotoSettingPage() {
        logOut()
    }
}

/// 数据配置
extension MineMainPageViewController {
    
    func initTableViewData() {
        // 我的主页
        let pageRowModel = RowModel(title: "我的主页", className: NSStringFromClass(MineMainPageNormalCell.self), reuseIdentifier: MineMainPageNormalCellID)
        pageRowModel.imageName = "mine_user_page_icon"
        pageRowModel.selectorString = "gotoUserPage"
        let sectionModelOne = SectionModel(title: nil)
        sectionModelOne.mutableCells = [pageRowModel]
        sectionModelOne.headerHeight = 10
        sectionModelOne.footerHeigth = 0.1
        // 设置
        let settingRowModel = RowModel(title: "设置", className: NSStringFromClass(MineMainPageNormalCell.self), reuseIdentifier: MineMainPageNormalCellID)
        settingRowModel.imageName = "mine_setting_icon"
        settingRowModel.selectorString = "gotoSettingPage"
        let sectionModelTwo = SectionModel(title: nil)
        sectionModelTwo.mutableCells = [settingRowModel]
        sectionModelTwo.headerHeight = 10
        sectionModelTwo.footerHeigth = 0.1
        
        self.dataArray = [sectionModelOne, sectionModelTwo]
        tableView.reloadData()
    }
    
}

extension MineMainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        let selString = cellModel.selectorString
        if selString != nil {
            let selec = NSSelectorFromString(cellModel.selectorString ?? "")
            if self.responds(to: selec) {
                self.perform(selec, with: cellModel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = dataArray[section]
        return sectionModel.mutableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellModel.className!)
        if cell == nil {
            let className = NSClassFromString(cellModel.className!) as? UITableViewCell.Type
            cell = className!.init(style: cellModel.style, reuseIdentifier: cellModel.reuseIdentifier)
        }
        cellModel.indexPath = indexPath
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        let selString = cellModel.showDataString
        if selString != nil {
            let selec = NSSelectorFromString(cellModel.showDataString ?? "")
            if cell.responds(to: selec) {
                cell.perform(selec, with: cellModel)
            }
        }
        cell.accessoryType = cellModel.accessoryType
        cell.selectionStyle = cellModel.selectionStyle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        return cellModel.height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.footerHeigth
    }
}
