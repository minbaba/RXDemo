//
//  MomentDetailCommentCell.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentDetailCommentCell: UITableViewCell {
    
    @IBOutlet weak var avator: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contenLabel: UILabel!
    
    var model:MomentComment? {
        
        didSet {

            if let _ = model {
                avator.kf_setBackgroundImageWithURL((model?.headPortrait ?? "").mqimageUrl(.Smallest), forState: .Normal, placeholderImage: placeHolderImage)
                
                let mAttStr = NSMutableAttributedString(string: model!.remarkNickname, attributes: [NSFontAttributeName: FontSizeConf.Third.toFont(), NSForegroundColorAttributeName: ColorConf.Text.MarketName.toColor()])
                if model?.replaiedId != 0 {
                    mAttStr.appendAttributedString(NSAttributedString(string: "回复", attributes: [NSFontAttributeName: FontSizeConf.Third.toFont(), NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()]))
                    mAttStr.appendAttributedString(NSAttributedString(string: model!.replaiedUserNickname, attributes: [NSFontAttributeName: FontSizeConf.Third.toFont(), NSForegroundColorAttributeName: ColorConf.Text.MarketName.toColor()]))
                }
                nameLabel.attributedText = mAttStr
                
                timeLabel.text = model?.createTime.toDate.intervalDescription()
                
                contenLabel.attributedText = TextEmotionParser.instance.parse(NSMutableAttributedString(string: model!.content, attributes: [NSFontAttributeName: FontSizeConf.Third.toFont(), NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()]))
            }
        }
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
