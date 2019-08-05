//
//  UserDynamicViewController.swift
//  GMChat
//
//  Created by GXT on 2019/7/31.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class UserDynamicTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

class UserDynamicViewController: BaseViewController, UserDynamicNavigationBarViewDelegate {

    var userId: String?
    var childScrollView: UIScrollView?
    
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
        setupViews()
        fetchListData()
    }
    
    func leftBtnClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.tableHeaderView = infoView
        view.addSubview(navigationView)
    }
    
    lazy var tableView: UserDynamicTableView = {
        let tableView = UserDynamicTableView(frame: CGRect(x: 0, y: -kStatusBarHeight, width: SCREEN_WIDTH, height: SCREEN_HEIGHT + kStatusBarHeight), style: .plain)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    lazy var infoView: UserDynamicInfoView = {
        let infoView = UserDynamicInfoView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: UserDynamicInfoViewH))
        return infoView
    }()
    
    lazy var navigationView: UserDynamicNavigationBarView = {
        let navi = UserDynamicNavigationBarView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: kTopHeight))
        navi.bgImageView.alpha = 0
        navi.nameLab.alpha = 0
        navi.delegate = self
        return navi
    }()
}

extension UserDynamicViewController {
    func fetchListData() {
        fetchUserInfo(userId: userId!, type: BookListModel.self) { (result) in
            if result.result {
                infoView.listModel = result.model
                navigationView.listModel = result.model
            }
        }
        
        let id: Int = Int(arc4random() % 7) + 1
        let imageName = "dynamic_img_bg_\(id)"
        let image = UIImage(named: imageName)
        infoView.bgImageView.image = image!
        navigationView.bgImageView.image = image!
    }
}

extension UserDynamicViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: NSStringFromClass(UITableViewCell.self))
            // cell 添加动态列表controller
            let dynamicVC = DynamicListViewController()
            dynamicVC.pushCommentView.extraH = UserDynamicInfoViewH
            dynamicVC.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            dynamicVC.delegate = self
            cell?.addSubview(dynamicVC.view)
            self.addChild(dynamicVC)
            dynamicVC.didMove(toParent: self)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension UserDynamicViewController: DynamicListViewControllerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        navigationAnimation(offsetY: scrollView.contentOffset.y + kStatusBarHeight)
        
        if childScrollView != nil && childScrollView!.contentOffset.y > 0 {
            self.tableView.contentOffset = CGPoint(x: 0, y: UserDynamicInfoViewH - kStatusBarHeight)
        }
        
        if scrollView.contentOffset.y + kStatusBarHeight < UserDynamicInfoViewH {
            NotificationCenter.default.post(name: userDynamicLeaveFromTopScrollNotice, object: nil)
        }
    }
    
    func scrollViewIsScrolling(scrollView: UIScrollView) {
        childScrollView = scrollView
        
        if self.tableView.contentOffset.y + kStatusBarHeight < UserDynamicInfoViewH  {
            scrollView.contentOffset = CGPoint.zero
            scrollView.showsVerticalScrollIndicator = false
        } else {
            self.tableView.contentOffset = CGPoint(x: 0, y: UserDynamicInfoViewH - kStatusBarHeight)
            scrollView.showsVerticalScrollIndicator = true
        }
        
    }
    
    /// 处理header滑动导航栏视图变化
    func navigationAnimation(offsetY: CGFloat) {
        var percent = offsetY / kTopHeight
        
        if percent >= 1 { percent = 1 }
        if percent < 0 { percent = 0 }
        
        navigationView.nameLab.alpha = percent
        if offsetY > 0 {
            navigationView.bgImageView.alpha = 1
        } else {
            navigationView.bgImageView.alpha = 0
        }
        
        if offsetY > 0 && offsetY < (UserDynamicInfoViewH - kTopHeight) {
            navigationView.bgImageView.snp_updateConstraints { (make) in
                make.top.equalTo(-offsetY)
            }
        }
        
        if offsetY < 0 {
            infoView.bgImageView.snp_updateConstraints { (make) in
                make.top.equalTo(offsetY)
            }
        }
    }
    
}
