//
//  DynamicListViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//
/**
 现有的动态cell类型：
 1、纯文本
 2、纯图片
 3、文本和图片
 */
import UIKit

class DynamicListViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动态"
        setupNavigationItem(icon: "dynamic_publish_icon", highIcon: "dynamic_publish_icon", isLeft: false)
        setupViews()
        fetchListData()
    }
    
    override func rightBtnClicked(sender: UIButton) {
        let publishNA = BaseNavigationViewController(rootViewController: PublishDynamicViewController())
        present(publishNA, animated: true, completion: nil)
    }
    
    func setupViews() {
        view.addSubview(tableView)
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kTopHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kTopHeight - kTabBarHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = color_246
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        return tableView
    }()
    
    lazy var dataArray: [DynamicSectionModel] = {
        let dataArray: [DynamicSectionModel] = []
        return dataArray
    }()
}


extension DynamicListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = dataArray[section]
        return sectionModel.mutableCells.count
    }
    /// 点赞和评论
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
    /// 动态内容
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = dataArray[section]
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionModel.reuseIdentifier!)
        if  headerView == nil {
            let className = NSClassFromString(sectionModel.className!) as? UITableViewHeaderFooterView.Type
            headerView = className!.init(reuseIdentifier: sectionModel.reuseIdentifier)
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let sectionModel = dataArray[section]
        let selString = sectionModel.showDataString
        if selString != nil {
            let selec = NSSelectorFromString(sectionModel.showDataString ?? "")
            if view.responds(to: selec) {
                view.perform(selec, with: sectionModel)
            }
        }
        sectionModel.section = section
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
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
/// 数据组装和处理
extension DynamicListViewController {
    
    func fetchListData() {
        
        fetchDynamicList { (listArray) in
            for listModel in listArray {
                dataArray.append(configSectionData(listModel: listModel))
            }
        }
        tableView.reloadData()
        
    }
    
    func configSectionData(listModel: DynamicListModel) -> DynamicSectionModel {
        /// 点赞的cell
        let likesModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
        likesModel.height = 64
        likesModel.accessoryType = .none
        /// 评论的cell
        /// 动态内容
        let sectionModel = DynamicSectionModel()
        sectionModel.className = NSStringFromClass(DynamicListContentBaseView.self)
        sectionModel.reuseIdentifier = DynamicListContentBaseViewID
        sectionModel.headerHeight = DynamicListContentBaseViewH
        sectionModel.footerHeigth = 0.1
        sectionModel.showDataString = "showDataWithSectionModel:"
        sectionModel.dataModel = listModel
        return sectionModel
    }
}
