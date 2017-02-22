//
//  WaitAlert.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/7/4.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class WaitAlert: AlertManager {
    
    static let instance = WaitAlert()
    
    private let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    private override init() {
        super.init()
        
        touchHide = false
        
        let view = UIView(frame: CGRectMake(0, 0, 130, 40))
        view.mq_setCornerRadius(2.5)
        view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
        indicator.frame = CGRectMake(10, 10, 20, 20)
        
        view.addSubview(indicator)
        let label = Factory.firstLabel
        label.textColor = ColorConf.Text.White.toColor()
        label.frame = CGRectMake(40, 0, 80, 40)
        label.text = "努力加载中"
        view.addSubview(label)
        self.displayView = view
    }
    
    override func show(animated: Bool = true, completed: ((Void) -> Void)? = nil, onHiden: completeHander? = nil) {
        indicator.startAnimating()
        super.show(animated, completed: completed, onHiden: onHiden)
        sleep(1/2)
    }
    
    override func hide(animated: Bool = true, completed: ((Void) -> Void)? = nil) {
        indicator.stopAnimating()
        super.hide(animated, completed: completed)
    }
}

