//
//  UserDynamicInfoView.swift
//  GMChat
//
//  Created by GXT on 2019/8/2.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
let UserDynamicInfoViewH: CGFloat = 240//84 + kTopHeight + KW(72)
class UserDynamicInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    var listModel: BookListModel? {
        didSet {
            guard let listModel = listModel else { return }
            viewShow(model: listModel)
        }
    }
    
    func viewShow(model: BookListModel) {
        headerImageView.netImage(url: model.photo, placeholderImage: headerPlaceholderImage)
        nameLab.text = model.name
        if model.id == UserInfo.shared.userId {
            btn.isSelected = false
        } else {
            btn.isSelected = true
        }
    }
    
    @objc func btnClicked() {
        if listModel!.id == UserInfo.shared.userId { // 发布动态
            let publistVC = PublishDynamicViewController()
            let publishNA = BaseNavigationViewController(rootViewController: publistVC)
            findController().present(publishNA, animated: true, completion: nil)
        } else { // 发消息
            let sessionDetail = SessionDetailViewController()
            sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
            sessionDetail.targetId = listModel?.id
            sessionDetail.title = listModel?.name
            sessionDetail.displayUserNameInCell = false
            findNavigator().pushViewController(sessionDetail, animated: true)
        }
    }
    
    
    @objc func openPhotoBrowser() {
        let loader = JXKingfisherLoader()
        let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return 1
        }, placeholder: { index -> UIImage? in
            return headerPlaceholderImage
        }) { [weak self] index -> String? in
            return self?.listModel?.photo
        }
        let delegate = JXDefaultPageControlDelegate()
        let trans = JXPhotoBrowserZoomTransitioning { [weak self] (browser, index, view) -> UIView? in
            return self?.headerImageView
        }
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate, transDelegate: trans)
            .show(pageIndex: 0)
    }
    
    func setupViews() {
        bgImageView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        effectImageView.snp_makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        headerImageView.snp_makeConstraints { (make) in
            make.top.equalTo(kTopHeight - 14)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: KW(72), height: KW(72)))
        }
        nameLab.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerImageView.snp_bottom).offset(12)
        }
        btn.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(nameLab.snp_bottom).offset(12)
            make.size.equalTo(CGSize(width: 86, height: 32))
        }
    }
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.contentMode = UIView.ContentMode.scaleAspectFill
        bgImageView.clipsToBounds = true
        self.addSubview(bgImageView)
        return bgImageView
    }()
    
    lazy var effectImageView: UIImageView = {
        let effectImageView = UIImageView(image: UIImage(named: "dynamic_user_page_effect_image"))
        bgImageView.addSubview(effectImageView)
        return effectImageView
    }()
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: headerPlaceholderImage)
        headerImageView.layer.cornerRadius = KW(72) / 2
        headerImageView.layer.masksToBounds = true
        headerImageView.contentMode = UIView.ContentMode.scaleAspectFill
        headerImageView.layer.borderColor = UIColor.white.cgColor
        headerImageView.layer.borderWidth = 1.0
        headerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openPhotoBrowser))
        headerImageView.addGestureRecognizer(tap)
        self.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = .white
        nameLab.font = FONT(18)
        self.addSubview(nameLab)
        return nameLab
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle(" 发布", for: .normal)
        btn.setImage(UIImage(named: "dynamic_user_page_push_btn_icon"), for: .normal)
        btn.setTitle(" 发消息", for: .selected)
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 4
        btn.titleLabel?.font = FONT(14)
        btn.setTitleColor(color_333333, for: .normal)
        self.addSubview(btn)
        btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        return btn
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
