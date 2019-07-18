//
//  DynamicListLikesCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import Kingfisher

let DynamicListLikesCellID = "DynamicListLikesCellID"

let dynamicListlikesCellBaseH: CGFloat = 40
/// 头像宽
let likesHeaderImageW: CGFloat = 30
/// 头像高
let likesHeaderImageH: CGFloat = 30
/// 第一行头像距离顶部的边距
let likesHeaderImageTopDis: CGFloat = 10
/// 头像的左右上学间距
let likesHeaderImgageDis: CGFloat = 5
/// 第一列头像距离左边的距离
let likesHeaderImageLeftDis: CGFloat = 20 + DynamicListHeaderImageViewW
/// 头像总宽度
let likesHeaderImageTotalW = SCREEN_WIDTH - 30 - DynamicListHeaderImageViewW
/// 每行显示的头像个数
let likesLineHeaderCount = floor((likesHeaderImageTotalW + likesHeaderImgageDis) / (likesHeaderImageW + likesHeaderImgageDis))

private let headerImageViewTag = 1000

class DynamicListLikesCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        
        let listModel = rowModel.dataModel as! DynamicListModel
        
        for view in contentView.subviews {
            if view != likesImgeView && view.tag > (listModel.likes.count + headerImageViewTag - 1) {
                view.isHidden = true
            }
        }

        for index in 0..<listModel.likes.count {
            
            let line = floor(CGFloat(index) / likesLineHeaderCount) // 行
            let row = CGFloat(index).truncatingRemainder(dividingBy: likesLineHeaderCount) // 列
            var headerImageView = contentView.viewWithTag(headerImageViewTag + index)
            
            if headerImageView == nil {
                headerImageView = UIImageView(image: headerPlaceholderImage)
                headerImageView!.tag = headerImageViewTag + index
                contentView.addSubview(headerImageView!)
                headerImageView!.snp_makeConstraints { (make) in
                    make.left.equalTo(likesHeaderImageLeftDis + (likesHeaderImageW + likesHeaderImgageDis) * row)
                    make.top.equalTo(likesHeaderImageTopDis + (likesHeaderImageH + likesHeaderImgageDis) * line)
                    make.size.equalTo(CGSize(width: likesHeaderImageW, height: likesHeaderImageH))
                }
            }
            guard let imageView: UIImageView = (headerImageView as? UIImageView) else {return}
            
            imageView.isHidden = false
            
            let photoString = listModel.likes[index].photo
            
            let photoImage = imageDic[photoString]
            if let photoImage = photoImage {
                imageView.image = photoImage
            } else {
                imageView.kf.setImage(with: URL(string: photoString), placeholder: headerPlaceholderImage, options: [.transition(.fade(0.2))], progressBlock: nil) { [weak self] (image, error, cacheType, url)  in
                    DispatchQueue.global().async {
                        guard let image = image else {return}
                        let w = image.size.width > image.size.height ? image.size.height : image.size.width
                        let imagee = image.byResize(to: CGSize(width: w, height: w))
                        let imageee = imagee!.byRoundCornerRadius(w / 10.0)
                        self?.imageDic[photoString] = imageee
                        DispatchQueue.main.async {
                            imageView.image = imageee
                        }
                    }
                }
            }

            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer { [weak self] (ges) in
                let userModel = listModel.likes[index]
                // 点击跳转到聊天界面  后续改为个人主页
                let sessionDetail = SessionDetailViewController()
                sessionDetail.conversationType = RCConversationType.ConversationType_PRIVATE
                sessionDetail.targetId = userModel.id
                sessionDetail.title = userModel.name
                sessionDetail.displayUserNameInCell = false
                self?.findNavigator().pushViewController(sessionDetail, animated: true)
            }
            imageView.addGestureRecognizer(tap)
            
        }
        
        
    }
    
    func setupViews() {
        backgroundColor = UIColor.withRGB(243, 243, 245)
        likesImgeView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp_left).offset(27)
            make.centerY.equalTo(self.contentView.snp_top).offset(dynamicListlikesCellBaseH / 2 + 5)
        }
    }
    
    lazy var likesImgeView: UIImageView = {
        let likesImageView = UIImageView(image: UIImage(named: "dynamic_comment_finger_default"))
        self.contentView.addSubview(likesImageView)
        return likesImageView
    }()
    
    lazy var imageDic: [String: UIImage] = {
        let imageDic = [String: UIImage]()
        return imageDic
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
