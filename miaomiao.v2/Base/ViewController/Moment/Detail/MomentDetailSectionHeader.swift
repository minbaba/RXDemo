//
//  MomentDetailSectionHeader.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentDetailSectionHeader: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentHorizontalAlignment = .Left
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
        
        self.titleLabel?.font = FontSizeConf.Third.toFont()
        self.setTitleColor(ColorConf.Text.SecondTextColor.toColor(), forState: .Normal)
        
        backgroundColor = ColorConf.View.White.toColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
