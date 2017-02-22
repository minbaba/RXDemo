//
//  UIColor+hexString.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/28.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

extension UIColor {
    
    
    convenience init(hexStr:String, alpha:Double = 1) {
        
        
        var red:UInt32 = 0
        NSScanner(string: hexStr[0...1]).scanHexInt(&red)
        
        var green:UInt32 = 0
        NSScanner(string: hexStr[2...3]).scanHexInt(&green)
        
        var blue:UInt32 = 0
        NSScanner(string: hexStr[4...5]).scanHexInt(&blue)
        
        
        self.init(red: CGFloat(Double(red) / 255.0), green: CGFloat(Double(green) / 255.0), blue: CGFloat(Double(blue) / 255.0), alpha: CGFloat(alpha))
    }
}
