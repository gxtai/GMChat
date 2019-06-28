//
//  SearchResultCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/28.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
let SearchResultCellID = "SearchResultCellID"
class SearchResultCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        let resultModel: SearchResultModel = rowModel.dataModel as! SearchResultModel
        headerImageView.netImage(url: resultModel.portraitUri, placeholderImage: headerPlaceholderImage)
        nameLab.text = resultModel.name
        contentLab.text = resultModel.otherInformation
    }
    
    func setupViews() {
        headerImageView.snp_makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
            make.size.equalTo(CGSize(width: 44, height: 44))
        }
        
        nameLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.right.equalTo(-5)
            make.top.equalTo(10)
        }
        
        contentLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.right.equalTo(-5)
            make.top.equalTo(nameLab.snp_bottom).offset(3)
        }
    }
    
    lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView(image: UIImage(named: "common_user_header_image_place"))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        self.contentView.addSubview(headerImageView)
        return headerImageView
    }()
    
    lazy var nameLab: UILabel = {
        let nameLab = UILabel()
        nameLab.textColor = color_000000
        nameLab.font = FONT(16)
        self.contentView.addSubview(nameLab)
        return nameLab
    }()
    
    lazy var contentLab: UILabel = {
        let contentLab = UILabel()
        contentLab.textColor = color_999999
        contentLab.font = FONT(12)
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
