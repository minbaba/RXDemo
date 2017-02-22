//
//  HintAlert.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/15.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class HintAlert {

    let alert = AlertManager()
    let disView = UIView()
    let disLabel = UILabel()
    
    static let instance = HintAlert()
    
    private init() {
        
        alert.maskView.backgroundColor = UIColor.clearColor()
        alert.maskView.userInteractionEnabled = false
        
        disView.backgroundColor = UIColor(hexStr: "000000", alpha: 0.4)
        disView.mq_setCornerRadius(5)
        disView.addSubview(disLabel)
        disLabel.snp_makeConstraints {[weak disView] (make) in
            make.center.equalTo(disView!)
        }
        disLabel.font = FontSizeConf.Second.toFont()
        disLabel.textColor = ColorConf.Text.White.toColor()
        
        alert.displayView = disView
    }
    
    
    static func showText(str: String) {
        
        guard str.characters.count > 0 else {
            return
        }
        self.instance.disLabel.text = str
        let rect = self.instance.disLabel.sizeThatFits(CGSizeMake(screenWidth - 100, CGFloat(MAXFLOAT)))
        
        self.instance.disView.frame = CGRectMake(0, 0, rect.width + 40, rect.height + 40)
        self.instance.alert.displayView = self.instance.disView
        self.instance.alert.show(true, completed: nil)
        dispatch_after(dispatch_time(0, 1000000000), dispatch_get_main_queue()) {
            self.instance.alert.hide(true, completed: nil)
        }
    }
    
    static func hide() {
        self.instance.alert.hide(true, completed: nil)
    }
}
