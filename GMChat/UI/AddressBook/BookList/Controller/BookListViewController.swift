//
//  BookListViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/14.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SwiftyJSON

class BookListViewController: BaseViewController {

    var lastOffsetY: CGFloat = 0
    var isUpScroll: Bool = false
    var lastHeaderView: BookListHeaderView?
    var nextHeaderView: BookListHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "通讯录"
        setupViews()
        fetchAddressBookList()
    }
    /// 添加好友
    override func rightBtnClicked(sender: UIButton) {
        print("添加好友")
    }
    
    /// 验证消息
    @objc func notificationList(_ rowModel: RowModel) {
        print(rowModel)
    }
    
    /// 群聊列表
    @objc func teamAdvanceList(_ rowModel: RowModel) {
        print(rowModel)
    }
    
    /// 讨论组列表
    @objc func teamNormalList(_ rowModel: RowModel) {
        print(rowModel)
    }
    
    /// 服务号列表
    @objc func subscriptionList(_ rowModel: RowModel) {
        print(rowModel)
    }
    
    /// 黑名单
    @objc func blackList(_ rowModel: RowModel) {
        print(rowModel)
    }
    
    /// 点击通讯录
    @objc func clickedTheCell(_ rowModel: RowModel) {
        print(rowModel)
        let listModel: BookListModel = rowModel.dataModel as! BookListModel
        let sessionDetail = SessionDetailViewController()
        sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
        sessionDetail.targetId = listModel.id
        sessionDetail.title = listModel.name
        sessionDetail.displayUserNameInCell = false
        sessionDetail.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(sessionDetail, animated: true)
    }
    
    /// UI
    func setupViews() {
        setupNavigationItem(icon: "book_add_friends_btn_normal", highIcon: nil, isLeft: false)
        view.addSubview(tableView)
        view.addSubview(indexView)
    }

    /// lazy
    lazy var searchBar: SearchBar = {
        let searchBar = SearchBar(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kTopHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kTopHeight - kTabBarHeight), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.withRGB(246, 246, 246)
        tableView.tableHeaderView = self.searchBar
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var dataArray: [SectionModel] = {
        let dataArray: [SectionModel] = []
        return dataArray
    }()
    
    lazy var allFriendsListArray: [BookListModel] = {
        let allFriendsListArray: [BookListModel] = []
        return allFriendsListArray
    }()
    
    lazy var charactorsArray: [String] = {
        let charactorsArray: [String] = []
        return charactorsArray
    }()
    
    lazy var indexView: BookListIndexView = {
        let indexView = BookListIndexView(frame: .zero)
        indexView.delegate = self
        return indexView
    }()
}

/// 数据组装和排序
extension BookListViewController {
    /// 获取通讯录的数据
    func fetchAddressBookList() {
        
        fetchAllAddressBookList { (listArray) in
            allFriendsListArray = listArray
            getAllfriendNameMetter(modelList: allFriendsListArray)
            defaultList()
            tableView.reloadData()
            indexView.reloadIndex(charactorsArray: charactorsArray)
        }
        
    }
    
    /// default list
    func defaultList() {
        let imageArray = ["book_notification_normal", "book_team_advance_normal", "book_team_normal_normal", "book_subscription_list_icon", "book_black_list_normal"]
        let titleArray = ["验证消息", "群聊", "讨论组", "服务号", "黑名单"]
        let selStrArray = ["notificationList:", "teamAdvanceList:", "teamNormalList:", "subscriptionList:", "blackList:"]
        let sectionModel = SectionModel()
        for i in 0..<imageArray.count {
            let rowModel = RowModel(title: titleArray[i], className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
            rowModel.imageName = imageArray[i]
            rowModel.height = 50
            rowModel.accessoryType = .none
            rowModel.showDataString = "showDefaultDataWithRowModel:"
            rowModel.selectorString = selStrArray[i]
            sectionModel.mutableCells.append(rowModel)
        }
        
        dataArray.insert(sectionModel, at: 0)
    }
    
    /// 首字母相同的放在一起
    func getAllfriendNameMetter(modelList: [BookListModel]){
        
        for friendModel in modelList {
            
            let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
            rowModel.height = 50
            rowModel.accessoryType = .none
            rowModel.selectorString = "clickedTheCell:"
            rowModel.dataModel = friendModel
            
            
            let charactor = friendModel.firstCharactor
            
            var isNewCharactor = true
            
            for sectionModel in dataArray {
                if sectionModel.title == charactor {
                    isNewCharactor = false
                    sectionModel.mutableCells.append(rowModel)
                    break
                }
            }
            
            if isNewCharactor {
                let currentSectionModel = SectionModel(title: charactor)
                currentSectionModel.headerHeight = 24;
                currentSectionModel.mutableCells.append(rowModel)
                charactorsArray.append(charactor)
                dataArray.append(currentSectionModel)
            }
        }
    }
    
}

/// search
extension BookListViewController: SearchBarDelegate, BookListIndexViewDelegate {
    func clickedTheSearchBar() {
        present(SearchPageViewController(), animated: false, completion: nil)
    }
    
    func touchTheChactor(index: Int, lastIndex: Int, charactor: String) {
        if index > lastIndex {
            isUpScroll = true
        } else {
            isUpScroll = false
        }
        tableView.scrollToRow(at: IndexPath(row: 0, section: index), at: .top, animated: false)
    }
}

/// tableview delegate datasource
extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
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
            let className = NSClassFromString(cellModel.className!) as? UITableViewCell.Type//swiftClassFromString(className: cellModel.className!) as? UITableViewCell.Type
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
        return CGFloat(cellModel.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionModel = dataArray[section]
        
        if sectionModel.headerHeight < 1 {
            return nil
        }
        
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BookListHeaderViewID)
        
        if headerView == nil {
            headerView = BookListHeaderView(reuseIdentifier: BookListHeaderViewID)
        }

        (headerView as! BookListHeaderView).title = sectionModel.title
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if (self.tableView.isDragging || self.tableView.isDecelerating) && isUpScroll {

            (view as? BookListHeaderView)?.titleColor = UIColor.withHex(hexString: "#999999")
            (view as? BookListHeaderView)?.contentView.backgroundColor = UIColor.withRGB(246, 246, 246)
            
            let nextHeader = tableView.headerView(forSection: section + 1)
            (nextHeader as? BookListHeaderView)?.titleColor = mainColor
            (nextHeader as? BookListHeaderView)?.contentView.backgroundColor = .white
            
            indexView.changeTheIndex(currentSelectedIndex: section + 1, lastSelectedIndex: section)
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if !isUpScroll && (self.tableView.isDragging || self.tableView.isDecelerating) {

            (view as? BookListHeaderView)?.titleColor = mainColor
            (view as? BookListHeaderView)?.contentView.backgroundColor = .white
            
            let nextHeader = tableView.headerView(forSection: section + 1)
            (nextHeader as? BookListHeaderView)?.titleColor = UIColor.withHex(hexString: "#999999")
            (nextHeader as? BookListHeaderView)?.contentView.backgroundColor = UIColor.withRGB(246, 246, 246)
            
            indexView.changeTheIndex(currentSelectedIndex: section, lastSelectedIndex: section + 1)
            
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isUpScroll = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
    }
}
