//
//  UserTagModel.swift
//  miaomiao.v2
//
//  Created by minbaba on 16/4/12.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

//import UIKit
import Foundation



class UserTagModel {
    
    var type:ModelType!
    var text = ""
    var rect = CGRectMake(0, 0, 35, 12)
    var color:ColorConf.tag?
    var image:String?
    
    private init() {}
    
    
    init(type:ModelType, text:String = "") {
        
        
        self.type = type
        self.text = text
        color = [.Single, .Loving, .Married, .Female, .Male, .VIP, .Market][type.rawValue]
        image = [nil, nil, nil, "tag_icon_女", "tag_icon_男", "tag_icon_vip", nil][type.rawValue]
        
        if type == .Vip {
            rect.size.width = 12
        }
    }
    
    func tagButton() -> UIButton {
        
        let button = UIButton(type: .System)
        
        button.frame = rect
        button.setTitle(text, forState: .Normal)
        button.titleLabel?.font = UIFont.systemFontOfSize(12)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        if let img = image {
            button.setImage(UIImage(named: img), forState: .Normal)
        }
        
        button.mq_setCornerRadius(1)
        
        return button
    }
    
    func tagButton(origin:CGPoint) -> UIButton {
        let button = tagButton()
        
        var rect = self.rect
        rect.origin = origin
        button.frame = rect
        
        return button
    }
    
    enum ModelType:Int {
        case Alone = 0
        case Loving = 1
        case Married = 2
        case FeMale = 3
        case Male = 4
        case Vip = 5
        case Market = 6
    }
}

