//
//  BaseTextView.swift
//  miaomiao.v2
//
//  Created by 郑敏 on 16/4/26.
//  Copyright © 2016年 MiaoquTech Inc. All rights reserved.
//

import UIKit

class BaseTextView: UITextView {


    override var text: String! {
        
        get {
            return super.text
        }
        
        set {
            super.text = newValue
        }
    }
    
    var placeHolder: String? {
    
        set {
        
        }
        
        get {
            
        }
        
    }
    
    
    
    
    
    
}
