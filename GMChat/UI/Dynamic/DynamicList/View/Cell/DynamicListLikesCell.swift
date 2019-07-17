//
//  DynamicListLikesCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/7/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

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

class DynamicListLikesCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        
        for view in contentView.subviews {
            if view != likesImgeView {
                view.removeFromSuperview()
            }
        }
        
        let listModel = rowModel.dataModel as! DynamicListModel

        for index in 0..<listModel.likes.count {
            let line = floor(CGFloat(index) / likesLineHeaderCount) // 行
            let row = CGFloat(index).truncatingRemainder(dividingBy: likesLineHeaderCount) // 列
            let imageView = UIImageView(image: headerPlaceholderImage)
            contentView.addSubview(imageView)
            imageView.snp_makeConstraints { (make) in
                make.left.equalTo(likesHeaderImageLeftDis + (likesHeaderImageW + likesHeaderImgageDis) * row)
                make.top.equalTo(likesHeaderImageTopDis + (likesHeaderImageH + likesHeaderImgageDis) * line)
                make.size.equalTo(CGSize(width: likesHeaderImageW, height: likesHeaderImageH))
            }
            
            imageView.kf.setImage(with: URL(string: listModel.user.photo), placeholder: headerPlaceholderImage, options: nil, progressBlock: nil) {(image, error, cacheType, url)  in
                guard let image = image else {return}
                let w = image.size.width > image.size.height ? image.size.height : image.size.width
                let imagee = image.byResize(to: CGSize(width: w, height: w))
                let imageee = imagee!.byRoundCornerRadius(w / 10.0)
                imageView.image = imageee
            }
            
        }
        
        
    }
    
    func setupViews() {
        backgroundColor = UIColor.withRGB(243, 243, 245)
        likesImgeView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp_left).offset(27)
            make.centerY.equalTo(self.contentView.snp_top).offset(dynamicListlikesCellBaseH / 2)
        }
    }
    
    lazy var likesImgeView: UIImageView = {
        let likesImageView = UIImageView(image: UIImage(named: "dynamic_comment_finger_default"))
        self.contentView.addSubview(likesImageView)
        return likesImageView
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
