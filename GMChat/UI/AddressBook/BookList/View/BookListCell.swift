//
//  BookListCell.swift
//  GMChat
//
//  Created by 花动传媒 on 2019/6/17.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

let BookListCellID = "BookListCellID"

class BookListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDefaultDataWithRowModel(_ rowModel: RowModel) {
        headerImageView.image = UIImage(named: rowModel.imageName!)
        nameLab.text = rowModel.title
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        let listModel = rowModel.dataModel as! BookListModel
        headerImageView.kf.setImage(with: URL(string: listModel.photo), placeholder: UIImage(named: "common_user_header_image_place"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLab.text = listModel.name
    }
    
    func setupViews() {
        headerImageView.snp_makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        nameLab.snp_makeConstraints { (make) in
            make.left.equalTo(headerImageView.snp_right).offset(10)
            make.centerY.equalTo(self.contentView.snp_centerY).offset(0)
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
        nameLab.textColor = UIColor.withHex(hexString: "#000000")
        nameLab.font = FONT(16)
        self.contentView.addSubview(nameLab)
        return nameLab
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
