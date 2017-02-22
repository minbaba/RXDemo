//
//  fontSize+color.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/12.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation

typealias completeHander = (Void) -> Void


enum FontSizeConf:Float {
    case First = 17
    case Second = 15
    case Third  = 12
    
    func toFont() -> UIFont {
        return UIFont.systemFontOfSize(CGFloat(self.rawValue))
    }
    
    
    static let sysFont = UIFont.systemFontOfSize(0)
    static func systemFontName() -> String {
        
        return sysFont.fontName
        
    }
}

enum ColorConf {
    
    
    /**
     标签颜色
     
     - single: 单身
     - loving: 恋爱
     */
    enum tag :String {
        
        case Single = "9bd393"
        
        case Loving = "b897ed"
        
        case Married = "d8cd80"
        
        case Male = "52c1ff"
        
        case Female = "e87ec3"
        
        case VIP = "ff5b5b"
        
        case Market = "d5a4fb"
        
        func toColor() -> UIColor {
            return UIColor(hexStr: self.rawValue)
        }
    }
    
    
    
    enum Text :String {
        case FirstTextColor = "585858"
        
        case SecondTextColor = "B5B5B5"
        
        case VipStrokColor = "FF5B5B"
        
        case VipGolden = "baa058"
        
        case SelectedBlue = "2ab1fc"
        
        case White = "f4f4f4"
        
        case MarketName = "407ebc"
        
        func toColor() -> UIColor {
            return UIColor(hexStr: self.rawValue)
        }
        
        
    }
    
    
    enum View:String {
        
        case Seprator = "EFEFF5"
        
        case BackGround = "F7F8FB"
        
        case NavigationBar = "393a3f"
        
        case MarketBack = "eeeef0"
        
        case TipRed = "ff5757"
        
        case MoneyRed = "E15656"
        
        case RichYellow = "baa058"
        
        case MoneyGreen = "118701"
        
        case White = "FFFFFF"
        
        case Disable = "f4f4f8"
        
        case Border = "e4e4e4"
        
        case RecorderRed = "FF7070"
        
        func toColor() -> UIColor {
            return UIColor(hexStr: self.rawValue)
        }
    }
    
}

