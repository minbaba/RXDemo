//
//  MomentMessageCell.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/16.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentMessageCell: UITableViewCell {
    
    
    @IBOutlet weak var avator: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fistImage: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        fistImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
