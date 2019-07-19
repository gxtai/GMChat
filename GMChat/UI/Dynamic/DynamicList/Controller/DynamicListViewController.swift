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
import SwiftyJSON

class DynamicListViewController: BaseViewController {

    var selectSectionModel: DynamicSectionModel?
    
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
        pushCommentView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(pushCommentView.height)
            make.bottom.equalTo(pushCommentView.height)
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = color_246
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        return tableView
    }()
    
    lazy var dataArray: [DynamicSectionModel] = {
        let dataArray: [DynamicSectionModel] = []
        return dataArray
    }()
    
    lazy var pushCommentView: DynamicPushCommentView = {
        let pushCommentView = DynamicPushCommentView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 132))
        self.view.addSubview(pushCommentView)
        pushCommentView.delegate = self
        return pushCommentView
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        return cellModel.height
    }
    
    /// 点赞和评论
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionModel = dataArray[indexPath.section]
        let cellModel = sectionModel.mutableCells[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellModel.reuseIdentifier!)
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
        sectionModel.section = section
        let selString = sectionModel.showDataString
        if selString != nil {
            let selec = NSSelectorFromString(sectionModel.showDataString ?? "")
            if view.responds(to: selec) {
                view.perform(selec, with: sectionModel)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionModel = dataArray[section]
        var footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "footerID")
        if  footerView == nil {
            footerView = UITableViewHeaderFooterView.init(reuseIdentifier: "footerID")
            footerView?.height = sectionModel.footerHeigth
            footerView?.contentView.backgroundColor = .white
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let sectionModel = dataArray[section]
        return sectionModel.footerHeigth
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushCommentView.dismiss()
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
        /// 动态内容
        let sectionModel = DynamicSectionModel()
        sectionModel.className = NSStringFromClass(DynamicListContentBaseView.self)
        sectionModel.reuseIdentifier = DynamicListContentBaseViewID
        sectionModel.headerHeight = listModel.total_h
        sectionModel.footerHeigth = 10
        sectionModel.showDataString = "showDataWithSectionModel:"
        sectionModel.dataModel = listModel
        sectionModel.delegate = self
        /// 点赞的cell
        if listModel.likes.count > 0 {
            sectionModel.mutableCells.append(likesModel(listModel: listModel))
        }
        /// 评论的cell
        for index in 0..<listModel.comments.count {
            var commentModel  = listModel.comments[index]
            if index == 0 {
                commentModel.isShowlikesImage = true
            }
            sectionModel.mutableCells.append(commentsModel(commentModel: commentModel))
        }
        return sectionModel
    }
    /// 点赞的cell
    func likesModel(listModel: DynamicListModel) -> RowModel {
        let likesModel = RowModel(title: nil, className: NSStringFromClass(DynamicListLikesCell.self), reuseIdentifier: DynamicListLikesCellID)
        likesModel.height = listModel.likes_h
        likesModel.accessoryType = .none
        likesModel.selectionStyle = .none
        likesModel.dataModel = listModel
        return likesModel
    }
    /// 评论的cell
    func commentsModel(commentModel: DynamicListCommentsModel) -> RowModel {
        let commentsModel = RowModel(title: nil, className: NSStringFromClass(DynamicListCommentsCell.self), reuseIdentifier: DynamicListCommentsCellID)
        commentsModel.height = commentModel.commentH
        commentsModel.accessoryType = .none
        commentsModel.selectionStyle = .none
        commentsModel.dataModel = commentModel
        return commentsModel
    }
}

/// content delegate
extension DynamicListViewController: DynamicListContentBaseViewDelegate {
    /// 点赞/取消点赞
    func isLikeTheDynamic(sectionModel: DynamicSectionModel, isLike: Bool) {
        let sec = dataArray[sectionModel.section]
        var contentModel = sec.dataModel!
        contentModel.has_like = isLike
        /// 模拟网络过程
        let userJson = ["id":UserInfo.shared.userId,
                        "name":UserInfo.shared.name,
                        "photo":UserInfo.shared.photo,
                        "phone":UserInfo.shared.phoneNum]
        let userModel = DynamicListUserModel(json: JSON(userJson))
        if isLike { // 点赞
            contentModel.likes.append(userModel)
        } else { // 取消点赞
            let index = contentModel.likes.firstIndex(where: { (model) -> Bool in
                return model.id == userModel.id
            })
            if let index = index {
                contentModel.likes.remove(at: index)
            }
            
        }
        contentModel.likes_h = DynamicListModel.likesH(likesArray: contentModel.likes)
        /// 判断之前是否有点赞的cell
        if (sectionModel.dataModel?.likes.count)! > 0 {
            sec.mutableCells.first?.height = contentModel.likes_h
            sec.mutableCells.first?.dataModel = contentModel
        } else {
            sec.mutableCells.insert(likesModel(listModel: contentModel), at: 0)
        }
        
        sec.dataModel = contentModel
        tableView.reloadData()
    }
    
    /// 评论框出现
    func pushTheCommentViewShow(sectionModel: DynamicSectionModel) {
        selectSectionModel = sectionModel
        pushCommentView.show()
    }
}

/// 发表评论
extension DynamicListViewController: DynamicPushCommentViewDelegate {
    
    func pushTheComment(comment: String) {
        
        let sec = dataArray[selectSectionModel!.section]
        var listModel = sec.dataModel!
        
        /// 模拟网络过程
        let dic: [String: Any] = ["id":"100",
                                  "body":comment,
                                  "created_at":Date().timeIntervalSince1970,
                                  "user":["id":UserInfo.shared.userId,
                                          "name":UserInfo.shared.name,
                                          "photo":UserInfo.shared.photo,
                                          "phone":UserInfo.shared.phoneNum]]
        var commentModel = DynamicListCommentsModel(json: JSON(dic))
        if listModel.comments.count == 0{
            commentModel.isShowlikesImage = true
        }
        listModel.comments.append(commentModel)
        
        sec.dataModel = listModel
        sec.mutableCells.append(commentsModel(commentModel: commentModel))
        
        tableView.reloadData()
        
    }
    
}



