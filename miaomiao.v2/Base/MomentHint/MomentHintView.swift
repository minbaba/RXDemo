//
//  MomentHintView.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/5/24.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class MomentHintView: UIButton {
    
    var text = "" {
        didSet {
            self.setTitle(text, forState: .Normal)
        }
    }
    
    var image:UIImage? {
        didSet {
            self.setImage(image, forState: .Normal)
        }
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView()
        
        self.imageView?.snp_makeConstraints(closure: { (make) in
            make.size.equalTo(CGSizeMake(25, 25))
        })
        
        self.imageView?.mq_setCornerRadius(12.5)
        view.backgroundColor = ColorConf.Text.SelectedBlue.toColor()
        self.insertSubview(view, belowSubview: self.imageView!)
        
        view.snp_makeConstraints {[weak self] (make) in
            make.top.left.equalTo(self!.imageView!).offset(-2.5)
            make.height.equalTo(30)
            make.right.equalTo(self!.titleLabel!.snp_right).offset(10)
        }
        view.userInteractionEnabled = false
        view.mq_setCornerRadius(15)
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        self.setTitleColor(ColorConf.Text.White.toColor(), forState: .Normal)
        self.titleLabel?.font = FontSizeConf.Third.toFont()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
