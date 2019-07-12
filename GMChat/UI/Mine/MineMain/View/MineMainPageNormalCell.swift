//
//  MineMainPageNormalCell.swift
//  GMChat
//
//  Created by GXT on 2019/6/27.
//  Copyright © 2019 GXT. All rights reserved.
//

import UIKit

let MineMainPageNormalCellID = "MineMainPageNormalCellID"

class MineMainPageNormalCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @objc func showDataWithRowModel(_ rowModel: RowModel) {
        iconImageView.image = UIImage(named: rowModel.imageName!)
        titleLab.text = rowModel.title
    }
    
    func setupViews() {
        iconImageView.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        titleLab.snp_makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp_right).offset(15)
            make.centerY.equalToSuperview()
        }
    }
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        self.contentView.addSubview(iconImageView)
        return iconImageView
    }()
    
    lazy var titleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = FONT(16)
        titleLab.textColor = color_333333
        self.contentView.addSubview(titleLab)
        return titleLab
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
