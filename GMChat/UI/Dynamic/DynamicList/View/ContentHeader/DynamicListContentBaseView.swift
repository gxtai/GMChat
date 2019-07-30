//
//  DynamicListContentBaseView.swift
//  GMChat
//
//  Created by GXT on 2019/7/16.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import AudioToolbox

let DynamicListContentBaseViewID = "DynamicListContentBaseViewID"
let DynamicListContentBaseViewH: CGFloat = 86.0
let DynamicListHeaderImageViewW: CGFloat = 34.0

protocol DynamicListContentBaseViewDelegate: NSObjectProtocol {
    func isLikeTheDynamic(sectionModel: DynamicSectionModel, isLike: Bool)
    func pushTheCommentViewShow(sectionModel: DynamicSectionModel)
}

class DynamicListContentBaseView: UITableViewHeaderFooterView {
    
    var sectionModel: DynamicSectionModel?
    weak var delegate: DynamicListContentBaseViewDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func likeBtnClicked(sender: UIButton) {
        AudioServicesPlaySystemSound(1519)
        delegate?.isLikeTheDynamic(sectionModel: sectionModel!, isLike: !sender.isSelected)
    }
    @objc func commentBtnClicked() {
        AudioServicesPlaySystemSound(1519)
        delegate?.pushTheCommentViewShow(sectionModel: sectionModel!)
    }
    
    @objc func showDataWithSectionModel(_ sectionModel: DynamicSectionModel) {
        
        self.sectionModel = sectionModel
        
        delegate = (sectionModel.delegate as! DynamicListContentBaseViewDelegate)
        
        let listModel: DynamicListModel = sectionModel.dataModel!
        
        let photoString = listModel.user.photo
        let photoImage = DynamicListImageStore.shared.listUserHeaderDic[photoString]
        if let photoImage = photoImage {
            headerImageView.image = photoImage
        } else {
            
            headerImageView.kf.setImage(with: URL(string: photoString), placeholder: headerPlaceholderImage, options: [.transition(.fade(0.2))], progressBlock: nil) { [weak self] (image, error, cacheType, url)  in
                DispatchQueue.global().async {
                    guard let image = image else {return}
                    let w = image.size.width > image.size.height ? image.size.height : image.size.width
                    let imagee = image.byResize(to: CGSize(width: w, height: w), contentMode: .scaleAspectFill)
                    let imageee = imagee!.byRoundCornerRadius(w / 10.0)
                    DynamicListImageStore.shared.listUserHeaderDic[photoString] = imageee
                    DispatchQueue.main.async {
                        self?.headerImageView.image = imageee
                    }
                }
            }
            
        }
        
        
        nameLab.text = listModel.user.name
        timeLab.text = listModel.created_at_string
        
        /// 内容
        contentLab.attributedText = listModel.attributedTextString
        contentLab.snp_updateConstraints { (make) in
            make.height.equalTo(listModel.content_h)
        }
        contentLab.highlightTapAction = { [weak self] (containerView, text, range, rect) in
            let highlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(range.location))
            self?.tapAction(label: containerView as! YYLabel, highlight: highlight as! YYTextHighlight, textRange: range)
        }
        
        /// 图片
        imagesView.snp.updateConstraints { (make) in
            make.height.equalTo(listModel.imagesH)
        }
        imagesView.listModel = listModel
        
        likeBtn.setTitle(listModel.like_count > 0 ? "\(listModel.likes.count)" : "", for: .normal)
        commentBtn.setTitle(listModel.feed_comment_count > 0 ? "\(listModel.comments.count)" : "", for: .normal)
        likeBtn.isSelected = listModel.has_like
    }
    
    func tapAction(label: YYLabel, highlight: YYTextHighlight, textRange: NSRange) {
        let info = highlight.userInfo
        let linkValue = "\(info!["linkValue"] ?? "")"
        fetchUserInfo(userName: linkValue, type: RCUserInfo.self) { (result) in
            if result.result == false { return }
            guard let user = result.model else { return }
            // 点击跳转到聊天界面  后续改为个人主页
            let sessionDetail = SessionDetailViewController()
            sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
            sessionDetail.targetId = user.userId
            sessionDetail.title = user.name
            sessionDetail.displayUserNameInCell = false
            findNavigator().pushViewController(sessionDetail, animated: true)
        }
    }
    
    func setupViews() {
        bgView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(6)
        }
        headerImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(12)
            make.size.equalTo(CGSize(width: DynamicListHeaderImageViewW, height: DynamicListHeaderImageViewW))
        }
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.top.equalTo(13)
        }
        timeLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.top.equalTo(nameLab.snp_bottom).offset(0)
        }
        contentLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.top.equalTo(timeLab.snp_bottom).offset(3)
            make.right.equalTo(-10)
            make.height.equalTo(0)
        }
        likeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(54)
            make.bottom.equalTo(-10)
        }
        commentBtn.snp_makeConstraints { (make) in
            make.left.equalTo(113)
            make.bottom.equalTo(-10)
        }
        
        imagesView.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.top.equalTo(contentLab.snp_bottom).offset(10)
            make.right.equalTo(-10)
            make.height.equalTo(0)
        }
        
        headerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer { [weak self] (ges) in
            let userModel = self?.sectionModel?.dataModel?.user
            // 点击跳转到聊天界面  后续改为个人主页
            let sessionDetail = SessionDetailViewController()
            sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
            sessionDetail.targetId = userModel?.id
            sessionDetail.title = userModel?.name
            sessionDetail.displayUserNameInCell = false
            self?.findNavigator().pushViewController(sessionDetail, animated: true)
        }
        headerImageView.addGestureRecognizer(tap)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        return bgView
    }()
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: headerPlaceholderImage)
        self.bgView.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLabl = UILabel()
        nameLabl.textColor = color_link
        nameLabl.font = FONT_Medium(14)
        nameLabl.text = "不喜勿争"
        self.bgView.addSubview(nameLabl)
        return nameLabl
    }()
    
    lazy var timeLab: UILabel = {
        let timeLab = UILabel()
        timeLab.textColor = color_b2b2b2
        timeLab.font = FONT(9)
        timeLab.text = "今天 16:37"
        self.bgView.addSubview(timeLab)
        return timeLab
    }()
    
    lazy var contentLab: YYLabel = {
        let contentLab = YYLabel()
        contentLab.textColor = color_51
        contentLab.font = FONT(14)
        contentLab.numberOfLines = 0
        self.bgView.addSubview(contentLab)
        
        let bundlePath = Bundle.main.path(forResource: "EmoticonQQ", ofType: "bundle")!
        let bundle = Bundle.init(path: bundlePath)
        let plistPath = bundle?.path(forResource: "infoEmotion", ofType: "plist")
        let dataArray = NSMutableArray(contentsOfFile: plistPath!)! as! [[String: String]]
        var mapper = [String: YYImage]()
        for dic in dataArray {
            let key = dic.keys.first!
            let value = dic.values.first!
            mapper[key] = emojiImage(name: value)
        }
        
        let parser = YYTextSimpleEmoticonParser()
        parser.emoticonMapper = mapper
        contentLab.textParser = parser

        return contentLab
    }()
    
    lazy var likeBtn: UIButton = {
        let likeBtn = UIButton(type: .custom)
        likeBtn.setTitle("126", for: .normal)
        likeBtn.setImage(UIImage(named: "dynamic_list_finger"), for: .normal)
        likeBtn.setImage(UIImage(named: "dynamic_list_finger_selected"), for: .selected)
        likeBtn.setTitleColor(color_888888, for: .normal)
        likeBtn.setTitleColor(UIColor.withHex(hexString: "#ea4335"), for: .selected)
        likeBtn.titleLabel?.font = FONT(12)
        self.bgView.addSubview(likeBtn)
        likeBtn.addTarget(self, action: #selector(likeBtnClicked(sender:)), for: .touchUpInside)
        return likeBtn
    }()
    
    lazy var commentBtn: UIButton = {
        let commentBtn = UIButton(type: .custom)
        commentBtn.setTitle("56", for: .normal)
        commentBtn.setImage(UIImage(named: "dynamic_list_comment_press"), for: .normal)
        commentBtn.setTitleColor(color_888888, for: .normal)
        commentBtn.titleLabel?.font = FONT(12)
        self.bgView.addSubview(commentBtn)
        commentBtn.addTarget(self, action: #selector(commentBtnClicked), for: .touchUpInside)
        return commentBtn
    }()
    
    lazy var imagesView: DynamicListImagesView = {
        let imagesView = DynamicListImagesView()
        self.bgView.addSubview(imagesView)
        return imagesView
    }()
}
