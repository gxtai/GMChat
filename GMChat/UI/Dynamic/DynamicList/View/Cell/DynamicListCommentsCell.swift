//
//  DynamicListCommentsCell.swift
//  GMChat
//
//  Created by GXT on 2019/7/19.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

class DynamicListCommentsCell: UITableViewCell {
    var rowModel: RowModel?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        self.rowModel = rowModel
        let commentModel = rowModel.dataModel as! DynamicListCommentsModel
        nameLab.text = commentModel.user.name
        contentLab.text = commentModel.body
        dateLab.text = commentModel.created_at_string
        
        iconImageView.isHidden = !commentModel.isShowlikesImage
        
        let photoString = commentModel.user.photo
        let photoImage = DynamicListImageStore.shared.commentsUserHeaderDic[photoString]
        if let photoImage = photoImage {
            headerImageView.image = photoImage
        } else {
            
            headerImageView.kf.setImage(with: URL(string: photoString), placeholder: headerPlaceholderImage, options: [.transition(.fade(0.2))], progressBlock: nil) { [weak self] (image, error, cacheType, url)  in
                DispatchQueue.global().async {
                    guard let image = image else {return}
                    let w = image.size.width > image.size.height ? image.size.height : image.size.width
                    let imagee = image.byResize(to: CGSize(width: w, height: w), contentMode: .scaleAspectFill)
                    let imageee = imagee!.byRoundCornerRadius(w / 10.0)
                    DynamicListImageStore.shared.commentsUserHeaderDic[photoString] = imageee
                    DispatchQueue.main.async {
                        self?.headerImageView.image = imageee
                    }
                }
            }
            
        }
        
    }
    
    func setupViews() {
        backgroundColor = UIColor.withRGB(243, 243, 245)
        
        headerImageView.snp_makeConstraints { (make) in
            make.left.equalTo(likesHeaderImageLeftDis)
            make.top.equalTo(5)
            make.size.equalTo(CGSize(width: likesHeaderImageW, height: likesHeaderImageH))
        }
        iconImageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView.snp_left).offset(27)
            make.centerY.equalTo(headerImageView.snp_centerY).offset(0)
        }
        nameLab.snp_makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalTo(headerImageView.snp_right).offset(10)
        }
        dateLab.snp_makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalTo(nameLab.snp_centerY).offset(0)
        }
        contentLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.top.equalTo(nameLab.snp_bottom).offset(0)
            make.right.equalTo(-10)
        }
        
        headerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer { [weak self] (ges) in
            let commentModel = self?.rowModel!.dataModel as! DynamicListCommentsModel
            let userModel = commentModel.user
            /// 个人主页
            let userDynamicVC = UserDynamicViewController()
            userDynamicVC.userId = userModel.id
            self?.findNavigator().pushViewController(userDynamicVC, animated: true)
        }
        headerImageView.addGestureRecognizer(tap)
    }
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: headerPlaceholderImage)
        self.contentView.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = color_link
        nameLab.font = FONT_Medium(12)
        self.contentView.addSubview(nameLab)
        return nameLab
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(image: UIImage(named: "dynamic_comment_comment"))
        self.contentView.addSubview(iconImageView)
        return iconImageView
    }()
    
    lazy var dateLab: UILabel = {
        let dateLab = UILabel()
        dateLab.textColor = color_b2b2b2
        dateLab.font = FONT(9)
        self.contentView.addSubview(dateLab)
        return dateLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel()
        contentLab.textColor = color_51
        contentLab.font = FONT(12)
        contentLab.numberOfLines = 0
        self.contentView.addSubview(contentLab)
        return contentLab
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
