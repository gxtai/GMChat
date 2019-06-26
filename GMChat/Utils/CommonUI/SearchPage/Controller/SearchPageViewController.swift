//
//  SearchPageViewController.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class SearchPageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchBookList()
    }
    
    func fetchBookList() {
        fetchAllAddressBookList { (listArray) in
            bookListArray = listArray
        }
    }
    
    func setupViews() {
        view.addSubview(searchBar)
        searchBar.cancleSearchCallback = { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
        view.addSubview(tableView)
    }
    
    lazy var bookListArray: [BookListModel] = {
        let bookListArray: [BookListModel] = []
        return bookListArray
    }()
    
    lazy var dataArray: [RowModel] = {
        let dataArray: [RowModel] = []
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
        tableView.backgroundColor = UIColor.withRGB(246, 246, 246)
        return tableView
    }()
}

extension SearchPageViewController: SearchPageSearchBarViewDelegate {
    func textFieldShouldClear(_ textField: UITextField) {
        
    }
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print(text)
        
        dataArray.removeAll()
        
        for listModel in bookListArray {
            if listModel.name.range(of: text) != nil {
                let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
                rowModel.accessoryType = .none
                rowModel.dataModel = listModel
                dataArray.append(rowModel)
            }
        }
        
//        // 中文
//        if text.isIncludeChinese() {
//            for listModel in bookListArray {
//                if listModel.name.range(of: text) != nil {
//                    let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
//                    rowModel.dataModel = listModel
//                    dataArray.append(rowModel)
//                }
//            }
//        } else {
//            // 拼音
//            for listModel in bookListArray {
//
//                if text.firCharactor() == listModel.name.firCharactor() {
//
//                    let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
//                    rowModel.dataModel = listModel
//                    dataArray.append(rowModel)
//                }
        
//                let pinyinString = listModel.name.pinyinString()
//                if pinyinString.range(of: text) != nil {
//                    let rowModel = RowModel(title: nil, className: NSStringFromClass(BookListCell.self), reuseIdentifier: BookListCellID)
//                    rowModel.dataModel = listModel
//                    dataArray.append(rowModel)
//                }
                
                
//            }
//        }
        
        tableView.reloadData()
    }
}

extension SearchPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = dataArray[indexPath.row]
        let selString = cellModel.selectorString
        if selString != nil {
            let selec = NSSelectorFromString(cellModel.selectorString ?? "")
            if self.responds(to: selec) {
                self.perform(selec, with: cellModel)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = dataArray[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellModel.className!)
        if cell == nil {
            let className = NSClassFromString(cellModel.className!) as? UITableViewCell.Type
            cell = className!.init(style: cellModel.style, reuseIdentifier: cellModel.reuseIdentifier)
        }
        cellModel.indexPath = indexPath
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellModel = dataArray[indexPath.row]
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
        let cellModel = dataArray[indexPath.row]
        return CGFloat(cellModel.height)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
