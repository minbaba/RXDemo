//
//  UIView+mqLayer.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/3/29.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

/// 屏幕宽
let screenWidth = UIScreen.mainScreen().bounds.size.width
/// 屏幕高
let screenHeight = UIScreen.mainScreen().bounds.size.height



extension UIView {
    
    
    /**
     设置圆角值
     
     - parameter radius: 圆角值
     */
    func mq_setCornerRadius(radius:Float) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.masksToBounds = true
    }
    
    
    /**
     设置边框颜色
     
     - parameter color: 颜色
     - parameter width: 宽度
     */
    func mq_setBorderColor(color:UIColor, width:Float) {
        
        self.layer.borderColor = color.CGColor
        self.layer.borderWidth = CGFloat(width)
        
    }
}
