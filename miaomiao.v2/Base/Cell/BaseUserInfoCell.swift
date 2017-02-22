//
//  BaseUserInfoCell.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/16.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class BaseUserInfoCell: UITableViewCell {
    
    
    var avator = UIImageView()
    var nameLabel = UILabel()
    var tagView = UILabel()
    var discriptLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avator)
        contentView.addSubview(nameLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(discriptLabel)
        
        avator.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(12)
            make.size.equalTo(CGSizeMake(60, 60))
        }
        nameLabel.textColor = ColorConf.Text.FirstTextColor.toColor()
        nameLabel.font = FontSizeConf.Second.toFont()
        nameLabel.snp_makeConstraints {[weak avator] (make) in
            make.left.equalTo(avator!.snp_right).offset(10)
            make.top.equalTo(avator!)
        }
        tagView.snp_makeConstraints {[weak avator, weak nameLabel] (make) in
            make.left.equalTo(nameLabel!)
            make.height.equalTo(15)
            make.centerY.equalTo(avator!)
        }
        discriptLabel.font = FontSizeConf.Third.toFont()
        discriptLabel.textColor = ColorConf.Text.SecondTextColor.toColor()
        discriptLabel.snp_makeConstraints {[weak nameLabel, weak avator] (make) in
            make.bottom.equalTo(avator!)
            make.left.equalTo(nameLabel!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
