//
//  Factory.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/6/6.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import Foundation


class Factory {
    
    static var firstLabel: UILabel {
        let lable = UILabel()
        lable.textColor = ColorConf.Text.FirstTextColor.toColor()
        lable.font = FontSizeConf.Second.toFont()
        return lable
    }
    
    static var secondLabel: UILabel {
        let lable = UILabel()
        lable.textColor = ColorConf.Text.SecondTextColor.toColor()
        lable.font = FontSizeConf.Third.toFont()
        return lable
    }
    
    static func firstAttr(str: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: str, attributes: [NSFontAttributeName: FontSizeConf.Second.toFont(), NSForegroundColorAttributeName: ColorConf.Text.FirstTextColor.toColor()])
    }
    
    
    static func seprator(frame: CGRect) -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = ColorConf.View.Seprator.toColor().CGColor
        layer.frame = frame
        return layer
    }
    
    
    static  func titleMake(prefix:NSAttributedString, count:Int, color:UIColor) -> NSAttributedString {
        
        let countAtt = NSAttributedString(string: String(count), attributes: [NSFontAttributeName: FontSizeConf.Third.toFont()])
        let result = NSMutableAttributedString(attributedString: prefix)
        result.appendAttributedString(countAtt)
        result.addAttributes([NSForegroundColorAttributeName: color], range: NSMakeRange(0, result.length))
        
        return result
    }
}

extension UIButton {
    
    func mqStyle() {
        
        self.setBackgroundImage(UIImage.colorImage(color: ColorConf.Text.SelectedBlue.toColor()), forState: .Normal)
        self.setBackgroundImage(UIImage.colorImage(color: ColorConf.View.Disable.toColor()), forState: .Disabled)
        self.mq_setCornerRadius(2.5)
        self.setTitleColor(ColorConf.Text.White.toColor(), forState: .Normal)
        self.titleLabel?.font = FontSizeConf.Second.toFont()
    }
    
}

extension UILabel {
    func firstLabel() {
        
        textColor = ColorConf.Text.FirstTextColor.toColor()
        font = FontSizeConf.Second.toFont()
    }
    
    func secondLabel() {
        
        textColor = ColorConf.Text.SecondTextColor.toColor()
        font = FontSizeConf.Third.toFont()
    }
}

