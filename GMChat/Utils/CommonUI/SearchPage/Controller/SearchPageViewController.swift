//
//  SearchPageViewController.swift
//  GMChat
//
//  Created by GXT on 2019/6/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SearchPageViewController: BaseViewController {
    
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
        setupViews()
        fetchBookList()
    }
    
    @objc func selectedTheUser(_ rowModel: RowModel) {
        let model: BookListModel = rowModel.dataModel as! BookListModel
        let sessionDetail = SessionDetailViewController()
        sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
        sessionDetail.targetId = model.id
        sessionDetail.title = model.name
        sessionDetail.displayUserNameInCell = false
        navigationController?.pushViewController(sessionDetail, animated: true)
    }
    @objc func selectedTheSession(_ rowModel: RowModel) {
        let model: SearchResultModel = rowModel.dataModel as! SearchResultModel
        let sessionDetailVC = SessionDetailViewController()
        sessionDetailVC.conversationType = model.conversationType
        sessionDetailVC.targetId = model.targetId
        sessionDetailVC.locatedMessageSentTime = model.locatedMessageSentTime
        sessionDetailVC.unReadMessage = Int(RCIMClient.shared().getUnreadCount(model.conversationType, targetId: model.targetId))
        navigationController?.pushViewController(sessionDetailVC, animated: true)
    }
    
    func fetchBookList() {
        fetchAllAddressBookList { (listArray) in
            bookListArray = listArray
        }
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        searchBar.cancleSearchCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        view.addSubview(tableView)
    }
    
    lazy var bookListArray: [BookListModel] = {
        let bookListArray: [BookListModel] = []
        return bookListArray
    }()
    
    lazy var dataArray: [SectionModel] = {
        var dataArray: [SectionModel] = []
        let titlesArr = ["联系人", "聊天记录"]
        for i in 0..<titlesArr.count {
            let sectionModel = SectionModel(title: titlesArr[i])
            sectionModel.headerHeight = 30
            sectionModel.footerHeigth = 0.1
            dataArray.append(sectionModel)
        }
        return dataArray
    }()
    
    lazy var searchBar: SearchPageSearchBarView = {
        let searchBar = SearchPageSearchBarView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: kTopHeight))
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kTopHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - kTopHeight - kTabBarHeight), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = color_246
        return tableView
    }()
}

extension SearchPageViewController: SearchPageSearchBarViewDelegate {
    func textFieldShouldClear(_ textField: UITextField) {
        
    }
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(text)
        
        dataArray.first?.mutableCells.removeAll()
        dataArray.last?.mutableCells.removeAll()
        // 联系人
        for listModel in bookListArray {
            if listModel.name.range(of: text) != nil {
                let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: "BookListCellID")
                rowModel.accessoryType = .none
                rowModel.dataModel = listModel
                rowModel.height = 64
                rowModel.selectorString = "selectedTheUser:"
                dataArray.first?.mutableCells.append(rowModel)
            }
        }
        // 聊天内容
        let messageArray = RCIMClient.shared()?.searchConversations([num(.ConversationType_GROUP), num(.ConversationType_PRIVATE)], messageType: [RCTextMessage.getObjectName(), RCRichContentMessage.getObjectName(), RCFileMessage.getObjectName()], keyword: text)
        guard let messageResult: [RCSearchConversationResult] = messageArray else {
            tableView.reloadData()
            return
        }
        
        for result in messageResult {
            // 组装搜索结果model
            var model: SearchResultModel = SearchResultModel()
            model.conversationType = result.conversation.conversationType
            model.targetId = result.conversation.targetId
            model.objectName = result.conversation.objectName
            let timeArray = RCIMClient.shared()?.searchMessages(result.conversation.conversationType, targetId: result.conversation.targetId, keyword: text, count: result.matchCount, startTime: 0)
            if timeArray!.count > 0 {
                let message: RCMessage = timeArray!.first!
                model.locatedMessageSentTime = message.sentTime
            }
            var string: String = ""
            if let lastestMessage = result.conversation.lastestMessage {
                if lastestMessage.isKind(of: RCRichContentMessage.self) {
                    string = (lastestMessage as! RCRichContentMessage).title
                } else if lastestMessage.isKind(of: RCFileMessage.self) {
                    string = (lastestMessage as! RCFileMessage).name
                } else {
                    string = RCKitUtility.formatMessage(lastestMessage)
                }
                string = string.replacingOccurrences(of: "\r\n", with: " ")
                string = string.replacingOccurrences(of: "\r", with: " ")
                string = string.replacingOccurrences(of: "\n", with: " ")
                model.otherInformation = string
            }
            
            if result.conversation.conversationType == .ConversationType_PRIVATE {
                
                fetchUserInfo(userId: result.conversation.targetId, type: RCUserInfo.self) { (userInfo) in
                    if userInfo.result {
                        model.name = userInfo.model!.name
                        model.portraitUri = userInfo.model!.portraitUri
                    }
                }
                
            } else if result.conversation.conversationType == .ConversationType_GROUP {
                
                /// 群组的带完善
                
            }
            model.searchType = .chatHistory
            model.count = result.matchCount
            
            let rowModel = RowModel(title: nil, className: NSStringFromClass(SearchResultCell.self), reuseIdentifier: SearchResultCellID)
            rowModel.accessoryType = .none
            rowModel.dataModel = model
            rowModel.height = 64
            rowModel.selectorString = "selectedTheSession:"
            dataArray.last?.mutableCells.append(rowModel)
        }
        tableView.reloadData()
    }
}

extension SearchPageViewController: UITableViewDelegate, UITableViewDataSource {
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
        return CGFloat(cellModel.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.footerHeigth
    }
}
